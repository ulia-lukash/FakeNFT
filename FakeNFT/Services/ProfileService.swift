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
    func updateProfile(json: [String: String],
                       id: String,
                       completion:  @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {
    
    private let networkClient: NetworkClient
    private let storage: ProfileStorageProtocol
    private let queue = DispatchQueue(label: "get-profile", qos: .userInitiated)
    
    init(networkClient: NetworkClient, storage: ProfileStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadProfile(id: String, completion: @escaping ProfileCompletion) {
        if let profile = storage.getProfile(with: id) {
            completion(.success(profile))
            return
        }
        
        let request = ProfileRequest()
        networkClient.send(request: request,
                           type: Profile.self,
                           completionQueue: queue) { [weak storage] result in
            guard let storage else { return }
            switch result {
            case .success(let profile):
                storage.saveProfile(profile: profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(json: [String: String], id: String, completion: @escaping ProfileCompletion) {
        let request = ProfilePutRequest(dto: json)
        networkClient.sendProfilePUT(request: request,
                                     completionQueue: queue) { [weak self, storage] result in
            guard let self else { return }
            storage.removeProfile(with: id)
            switch result {
            case .success():
                self.loadProfile(id: id) { result in
                    switch result {
                    case .success(let profile):
                        storage.saveProfile(profile: profile)
                        completion(.success(profile))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
