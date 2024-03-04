//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import Foundation

protocol ProfileStorageProtocol: AnyObject {
    func saveProfile(profile: Profile)
    func getProfile() -> Profile?
    func removeProfile()
}

final class ProfileStorageImpl {
    private var storage: Profile?
    private let syncQueue = DispatchQueue(label: "sync-profile-queue")
}

extension ProfileStorageImpl: ProfileStorageProtocol {
    func saveProfile(profile: Profile) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            self.storage = profile
        }
    }

    func getProfile() -> Profile? {
        syncQueue.sync { [weak self] in
            guard let self else { return nil }
            return self.storage
        }
    }

    func removeProfile() {
        syncQueue.sync { [weak self] in
            guard let self else { return }
            self.storage = nil
        }
    }
}
