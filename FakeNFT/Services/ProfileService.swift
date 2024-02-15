//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Григорий Машук on 13.02.24.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(id: String, completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient
    private let storage: ProfileStorageProtocol

    init(networkClient: NetworkClient, storage: ProfileStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadProfile(id: String, completion: @escaping ProfileCompletion) {
        if let profile = storage.getProfile(with: id) {
            completion(.success(profile))
            return
        }

        let request = ProfileRequest(id: id)
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                storage?.saveProfile(profile: profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setProfile(id: String, completion: @escaping ProfileCompletion) {
        if let profile = storage.getProfile(with: id) {
            completion(.success(profile))
            return
        }

        let request = ProfileRequest(id: id)
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                storage?.saveProfile(profile: profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
