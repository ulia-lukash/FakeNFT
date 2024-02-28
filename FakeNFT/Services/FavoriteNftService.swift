//
//  FavoriteNftService.swift
//  FakeNFT
//
//  Created by Григорий Машук on 27.02.24.
//

import Foundation

typealias likesNftCompletion = (Result<Likes, Error>) -> Void

protocol FavoriteNftServiceProtocol {
    func likes(likes: String, completion: @escaping likesNftCompletion)
    func loadLikesNft(listId: [String], completion: @escaping MyListNftCompletion)
}

final class FavoriteNftServiceImp {
    private let networkClient: NetworkClient
    private let loadMyNftService: LoadMyNftServiceProtocol
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        self.loadMyNftService = LoadMyNftServiceImp(networkClient: networkClient)
    }
}

extension FavoriteNftServiceImp: FavoriteNftServiceProtocol {
    func likes(likes: String, completion: @escaping likesNftCompletion) {
        let request = ProfilePutRequest(dto: likes)
        networkClient.send(request: request,
                           type: Likes.self) { result in
            switch result {
            case .success(let likes):
                completion(.success(likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadLikesNft(listId: [String], completion: @escaping MyListNftCompletion) {
        loadMyNftService.loadMyNft(listId: listId, completion: completion)
    }
}
