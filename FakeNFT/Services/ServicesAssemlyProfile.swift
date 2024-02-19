//
//  ServicesAssemlyProfile.swift
//  FakeNFT
//
//  Created by Григорий Машук on 13.02.24.
//

import Foundation

final class ServicesAssemlyProfile {
    private let networkClient: NetworkClient
    private let storage: ProfileStorageProtocol
    
    init(
        networkClient: NetworkClient,
        storage: ProfileStorageProtocol
    ) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient,
            storage: storage
        )
    }
}
