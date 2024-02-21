//
//  BasketService.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 19.02.2024.
//

import Foundation

typealias NftsCompletion = (Result<Nft, Error>) -> Void
typealias OrdersCompletion = (Result<[String], Error>) -> Void

protocol BasketServiceProtocol {
    func loadByNft(by id: String, completion: @escaping NftsCompletion)
    func updateByOrders(with nfts: [String], completion: @escaping OrdersCompletion)
    func loadByOrders(completion: @escaping OrdersCompletion)
}

final class BasketService: BasketServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadByNft(by id: String, completion: @escaping NftsCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateByOrders(with nfts: [String], completion: @escaping OrdersCompletion) {
        let request = PutOrderRequest(nfts: nfts, httpMethod: .put)
        networkClient.send(request: request, type: OrdersModel.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data.nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadByOrders(completion: @escaping OrdersCompletion) {
        let request = GetOrderRequest(httpMethod: .get)
        networkClient.send(request: request, type: OrdersModel.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data.nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
