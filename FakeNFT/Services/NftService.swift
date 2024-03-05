//
//  NftService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 21.02.2024.
//

import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias NftsArrayCompletion = (Result<[Nft], Error>) -> Void

typealias NftDataCompletion = (Result<NFTData, Error>) -> Void
typealias AllNFTsCompletion = (Result<[NFTData], Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadNftsNextPage(completion: @escaping NftsArrayCompletion)
    func loadNfts(withIds nfts: [String], completion: @escaping NftsArrayCompletion)

    func loadNftData(id: String, completion: @escaping NftDataCompletion)
    func loadUserNfts(nftIDS: [String], completion: @escaping AllNFTsCompletion)
}

final class NftServiceImpl: NftService {

    private var lastLoadedPage: Int?
    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadUserNfts(nftIDS: [String], completion: @escaping AllNFTsCompletion) {
        Task {
            let results = await loadNftsSequentially(ids: nftIDS)

            var loadedNfts: [NFTData] = []

            for result in results {
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    completion(.failure(error))
                }
            }

            if loadedNfts.count == nftIDS.count {
                completion(.success(loadedNfts))
            }
        }
    }

    func loadNftsSequentially(ids: [String]) async -> [Result<NFTData, Error>] {
        var results: [Result<NFTData, Error>] = []

        for id in ids {
            let result = await withCheckedContinuation { continuation in
                loadNftData(id: id) { result in
                    continuation.resume(returning: result)
                }
            }
            results.append(result)
        }

        return results
    }

    func loadNftData(id: String, completion: @escaping NftDataCompletion) {
        if let nft = storage.getNftData(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: NFTData.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadNftsNextPage(completion: @escaping NftsArrayCompletion) {
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        lastLoadedPage = nextPage

        let request = NFTsRequest(page: nextPage)

        networkClient.send(request: request, type: [Nft].self) { result in
            switch result {
            case .success(let nfts):
                completion(.success(nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadNfts(withIds nfts: [String], completion: @escaping NftsArrayCompletion) {
        var returnNfts: [Nft] = []

        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1

        for id in nfts {
            let operation = BlockOperation {
                let request = NFTRequest(id: id)
                var nft: Nft?

                let semaphore = DispatchSemaphore(value: 0)

                self.load(request: request) { result in
                    switch result {
                    case .success(let loadedNFT):
                        nft = loadedNFT
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                    semaphore.signal()
                }
                _ = semaphore.wait(timeout: .distantFuture)

                if let nft = nft {
                    returnNfts.append(nft)

                    if returnNfts.count == nfts.count {
                        completion(.success(returnNfts))
                    }
                }
            }
            operationQueue.addOperation(operation)
        }
    }

    func load(request: NetworkRequest,
              completion: @escaping NftCompletion) {
        networkClient.send(request: request,
                           type: Nft.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
