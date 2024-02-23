//
//  MyNFTStorage.swift
//  FakeNFT
//
//  Created by Григорий Машук on 20.02.24.
//

import Foundation

protocol MyNftStorageProtocol: AnyObject {
    func saveMyNft(_ myNft: [MyListNFT])
//    func getNft() -> MyNFT
    func addNft()
}

final class MyNftStorageImpl: MyNftStorageProtocol {
    private var storage: [MyListNFT] = []
    
    private let queue = DispatchQueue(label: "sync-myNft-queue")
    
    func saveMyNft(_ myNft: [MyListNFT]) {
        storage = myNft
    }
    
//    func getNft() -> MyNFT {
//        MyNFT(name: <#T##String#>, images: <#T##[String]#>, rating: <#T##Int#>, description: <#T##String#>, price: <#T##Float#>, author: <#T##String#>, id: <#T##String#>)
//    }
    
    func addNft() {
        
    }
    
    
}
