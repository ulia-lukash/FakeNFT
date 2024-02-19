//
//  BasketService.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 19.02.2024.
//

import Foundation

typealias NftsCompletion = (Result<Nft, Error>) -> Void
typealias OrderCompletion = (Result<[String], Error>) -> Void

protocol BasketServiceProtocol {
    func loadNft(by id: String, completion: @escaping NftsCompletion)
    func updateOrder(with nfts: [String], completion: @escaping OrderCompletion)
    func loadOrder(completion: @escaping OrderCompletion)
}

final class BasketService: BasketServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(
      networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
      }
    
    func loadNft(by id: String, completion: @escaping NftsCompletion) {
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
    
    func updateOrder(with nfts: [String], completion: @escaping OrderCompletion) {
        let request = PutOrderRequest(httpMethod: .put, dto: nfts)
        networkClient.send(request: request, type: OrdersModel.self) { result in
          switch result {
          case .success(let model):
            completion(.success(model.nfts))
          case .failure(let error):
            completion(.failure(error))
          }
        }
    }
    
    func loadOrder(completion: @escaping OrderCompletion) {
        let request = GetOrderRequest()
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
