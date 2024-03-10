//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Григорий Машук on 13.02.24.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void
typealias ProfileDataCompletion = (Result<ProfileData, Error>) -> Void
typealias OrderDataCompletion = (Result<OrderData, Error>) -> Void

protocol ProfileService {
    func loadProfile(id: String, completion: @escaping ProfileCompletion)
    func loadProfile(completion: @escaping ProfileCompletion)
    func updateProfile(dto: String, id: String,
                       completion: @escaping ProfileCompletion)
    func updateProfile(likes: [String], completion: @escaping ProfileCompletion)

    func loadProfile(id: String, completion: @escaping ProfileDataCompletion)
    func setLikes(nfts: [String], completion: @escaping ProfileDataCompletion)
    func loadOrder(completion: @escaping OrderDataCompletion)
    func setOrder(nfts: [String], completion: @escaping OrderDataCompletion)
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


    func loadProfile(id: String, completion: @escaping ProfileDataCompletion) {
        let request = ProfileByIdRequest(id: id)
        networkClient.send(request: request, type: ProfileData.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setLikes(nfts: [String], completion: @escaping ProfileDataCompletion) {
        let request = PutLikesRequest(nfts: nfts)

        networkClient.send(request: request, type: ProfileData.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadOrder(completion: @escaping OrderDataCompletion) {
        let request = GetOrderRequest()

        networkClient.send(request: request, type: OrderData.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setOrder(nfts: [String], completion: @escaping OrderDataCompletion) {
        let request = PutOrderRequest(nfts: nfts)

        networkClient.send(request: request, type: OrderData.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
