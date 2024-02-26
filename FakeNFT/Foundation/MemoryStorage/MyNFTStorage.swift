//
//  MyNFTStorage.swift
//  FakeNFT
//
//  Created by Григорий Машук on 20.02.24.
//

import Foundation

protocol MyNftStorageProtocol: AnyObject {
    func saveMyNft(_ myNft: [MyListNFT])
    func getNft() -> [MyListNFT]
    func updateStorage(nft: [MyListNFT])
}

final class MyNftStorageImpl: MyNftStorageProtocol {
    private var storage: [MyListNFT] = []
    
    private let queue = DispatchQueue(label: "sync-myNft-queue")
    
    func saveMyNft(_ myNft: [MyListNFT]) {
        queue.async { [weak self] in
            self?.storage = myNft
        }
    }
    
    func getNft() -> [MyListNFT] {
        queue.sync {  [weak self] in
            guard let self else { return [] }
            return self.storage
        }
    }
    
    func updateStorage(nft: [MyListNFT]) {
        queue.async { [weak self] in
            self?.storage = nft
        }
    }
}

