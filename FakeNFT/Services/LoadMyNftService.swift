//
//  LoadMyNftService.swift
//  FakeNFT
//
//  Created by Григорий Машук on 27.02.24.
//

import Foundation

protocol LoadMyNftServiceProtocol {
    func loadMyNft(listId: [String], completion: @escaping MyListNftCompletion)
}

// MARK: - LoadMyNftServiceImp
final class LoadMyNftServiceImp {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}
 
private extension LoadMyNftServiceImp {
    func load(request: NetworkRequest,
              completion: @escaping MyNftCompletion) {
        networkClient.send(request: request,
                           type: MyListNFT.self) { result in
            switch result {
            case .success(let myNft):
                completion(.success(myNft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchName(urlStr: String) -> String? {
        if let host = URL(string: urlStr)?.host {
            let components = host.components(separatedBy: "_")
            let combinedString = components.joined(separator: " ")
            return combinedString.capitalized
        }
        return nil
    }
    
    func loadNFT(listId: [String], completion: @escaping MyListNftCompletion) {
        var returnNft: [MyListNFT] = []
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        
        for id in listId {
            let operation = BlockOperation {
                let request = GetNFTRequest(id: id)
                var nft: MyListNFT?
                
                let semaphore = DispatchSemaphore(value: 0)
                
                self.load(request: request) { result in
                    switch result {
                    case .success(let loadedNFT):
                        nft = loadedNFT
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                    semaphore.signal()
                }
                _ = semaphore.wait(timeout: .distantFuture)
                
                if let nft = nft {
                    let name = self.searchName(urlStr: nft.author)
                    let myListNFT = MyListNFT(name: nft.name,
                                              images: nft.images,
                                              rating: nft.rating,
                                              description: nft.description,
                                              price: nft.price,
                                              author: name ?? "Grifon",
                                              id: nft.id)
                    returnNft.append(myListNFT)
                    
                    if returnNft.count == listId.count {
                        completion(.success(returnNft))
                    }
                }
            }
            operationQueue.addOperation(operation)
        }
    }
}

// MARK: - LoadMyNftServiceProtocol
extension LoadMyNftServiceImp: LoadMyNftServiceProtocol {
    func loadMyNft(listId: [String], completion: @escaping MyListNftCompletion) {
        loadNFT(listId: listId, completion: completion)
    }
}
