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
    func loadProfile(completion: @escaping ProfileCompletion)
    func updateProfile(dto: String, id: String,
                       completion: @escaping ProfileCompletion)
    func updateProfile(likes: [String], completion: @escaping ProfileCompletion)
}

// MARK: - ProfileServiceImpl
final class ProfileServiceImpl {
    private let networkClient: NetworkClient
    private let storage: ProfileStorageProtocol

    init(networkClient: NetworkClient, storage: ProfileStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }
}

// MARK: - ProfileService
extension ProfileServiceImpl: ProfileService {

    func loadProfile(id: String, completion: @escaping ProfileCompletion) {
        if let profile = storage.getProfile() {
            completion(.success(profile))
            return
        }
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
    func loadProfile(completion: @escaping ProfileCompletion) {
        if let profile = storage.getProfile() {
            completion(.success(profile))
            return
        }
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

    func updateProfile(dto: String, id: String, completion: @escaping ProfileCompletion) {
        let request = ProfilePutRequest(dto: dto)
        networkClient.send(request: request,
                           type: Profile.self) { [weak self, storage] result in
            guard let self else { return }
            storage.removeProfile()
            switch result {
            case .success:
                self.loadProfile { result in
                    switch result {
                    case .success(let profile):
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

    func updateProfile(likes: [String], completion: @escaping ProfileCompletion) {

        let dto = likes.map {"likes=\($0)"}.joined(separator: "&")
        let request = ProfilePutRequest(dto: dto)
        networkClient.send(request: request,
                           type: Profile.self) { [weak self, storage] result in
            guard let self else { return }
            storage.removeProfile()
            switch result {
            case .success:
                self.loadProfile { result in
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
