//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Григорий Машук on 12.02.24.
//

import Foundation

protocol ProfileStorageProtocol: AnyObject {
    func saveProfile(profile: Profile)
    func getProfile(with id: String) -> Profile?
    func removeProfile(with id: String)
    
    func saveSimpleProfile(profile: Profile)
    func getProfile() -> Profile?
    func removeProfile()
}

final class ProfileStorageImpl {
    private var storage: [String: Profile] = [:]
    private var simpleStorage: Profile?
    private let syncQueue = DispatchQueue(label: "sync-profile-queue")
}

extension ProfileStorageImpl: ProfileStorageProtocol {
    func saveSimpleProfile(profile: Profile) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            self.simpleStorage = profile
        }
    }
    
    func getProfile() -> Profile? {
        syncQueue.sync { [weak self] in
            guard let self else { return nil }
            return self.simpleStorage
        }
    }
    
    func removeProfile() {
        syncQueue.sync { [weak self] in
            guard let self else { return }
            self.simpleStorage = nil
        }
    }
    
    func saveProfile(profile: Profile) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            self.storage[profile.id] = profile
        }
    }
    
    func getProfile(with id: String) -> Profile? {
        syncQueue.sync { [weak self] in
            guard let self else { return nil }
            return self.storage[id]
        }
    }
    
    func removeProfile(with id: String) {
        syncQueue.sync { [weak self] in
            guard let self else { return }
            self.storage = storage.filter { $0.key != id }
        }
    }
}
