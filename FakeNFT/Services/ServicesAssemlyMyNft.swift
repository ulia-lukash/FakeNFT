//
//  MyNftServicesAssemly.swift
//  FakeNFT
//
//  Created by Григорий Машук on 20.02.24.
//

import Foundation

final class MyNftServicesAssemly {

    private let networkClient: NetworkClient
    private let nftStorage: MyNftStorageProtocol

    init(
        networkClient: NetworkClient,
        nftStorage: MyNftStorageProtocol
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: MyNFTServiceProtocol {
        MyNFTServiceIml(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
}
