//
//  MyNFTService.swift
//  FakeNFT
//
//  Created by Григорий Машук on 20.02.24.
//

import Foundation

typealias MyNftCompletion = (Result<MyListNFT, Error>) -> Void
typealias MyListNftCompletion = (Result<[MyListNFT], Error>) -> Void
typealias likeNftCompletion = (Result<Void, Error>) -> Void

protocol MyNFTServiceProtocol {
    func load(listId: [String], completion: @escaping MyListNftCompletion)
    func updateNftPut(dto: String,
                      completion: @escaping likeNftCompletion)
    func loadProfile(completion: @escaping ProfileCompletion)
    func getStorageNft() -> [MyListNFT]
    func updateStorage(nft: [MyListNFT])
}

//MARK: - MyNFTServiceIml
final class MyNFTServiceIml {
    private let networkClient: NetworkClient
    private let storage: MyNftStorageProtocol
    
    init(networkClient: NetworkClient, storage: MyNftStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }
}

private extension MyNFTServiceIml {
    //MARK: - private func
    func load(request: NetworkRequest,
              completion: @escaping MyNftCompletion) {
        networkClient.send(request: request,
                           type: MyListNFT.self) { result in
            switch result {
            case .success(let myNft):
                completion(.success(myNft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateLikeAndNftPut(request: NetworkRequest,
                             completion: @escaping likeNftCompletion) {
        networkClient.sendProfilePUT(request: request, completionQueue: .main) { result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchName(urlStr: String) -> String? {
        if let host = URL(string: urlStr)?.host {
            let components = host.components(separatedBy: "_")
            let combinedString = components.joined(separator: " ")
            return combinedString.capitalized
        }
        return nil
    }
    
    func loadMyNFT(listId: [String], completion: @escaping MyListNftCompletion)  {
        var returnNft: [MyListNFT] = []
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        for id in listId {
            let operation = BlockOperation {
                let request = MyNftRequest(id: id)
                var nft: MyListNFT?
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
                    let name = self.searchName(urlStr: nft.author)
                    let myListNFT = MyListNFT(name: nft.name,
                                              images: nft.images,
                                              rating: nft.rating,
                                              description: nft.description,
                                              price: nft.price,
                                              author: name ?? "Grifon",
                                              id: nft.id)
                    returnNft.append(myListNFT)
                    if returnNft.count == listId.count {
                        self.storage.saveMyNft(returnNft)
                        completion(.success(returnNft))
                    }
                }
            }
            operationQueue.addOperation(operation)
        }
    }
}

//MARK: - MyNFTServiceProtocol
extension MyNFTServiceIml: MyNFTServiceProtocol {
    func load(listId: [String], completion: @escaping MyListNftCompletion) {
        if !storage.getNft().isEmpty {
            completion(.success(storage.getNft()))
            return
        }
        loadMyNFT(listId: listId, completion: completion)
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request,
                           type: Profile.self) {result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
    func updateNftPut(dto: String,
                      completion: @escaping likeNftCompletion) {
                let request = ProfilePutRequest(dto: dto)
                updateLikeAndNftPut(request: request, completion: completion)
    }
    
    func updateStorage(nft: [MyListNFT]) {
        storage.updateStorage(nft: nft)
    }
    
    func getStorageNft() -> [MyListNFT] {
        storage.getNft()
    }
}

