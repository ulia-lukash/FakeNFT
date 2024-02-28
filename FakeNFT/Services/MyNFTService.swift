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
    private let loadMyNftService: LoadMyNftServiceProtocol
    
    init(networkClient: NetworkClient,
         storage: MyNftStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
        self.loadMyNftService = LoadMyNftServiceImp(networkClient: networkClient)
    }
}

private extension MyNFTServiceIml {
    //MARK: - private func
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
}

//MARK: - MyNFTServiceProtocol
extension MyNFTServiceIml: MyNFTServiceProtocol {
    func load(listId: [String], completion: @escaping MyListNftCompletion) {
        if !storage.getNft().isEmpty {
            completion(.success(storage.getNft()))
            return
        }
        loadMyNftService.loadMyNft(listId: listId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let listNft):
                self.storage.saveMyNft(listNft)
                completion(.success(listNft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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

