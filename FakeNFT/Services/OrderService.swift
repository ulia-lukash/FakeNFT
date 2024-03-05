//
//  OrderService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 21.02.2024.
//

import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol OrderService {
    func loadOrder(completion: @escaping OrderCompletion)
    func updateOrder(dto: String, completion: @escaping OrderCompletion)
    func updateOrder(nfts: [String], completion: @escaping OrderCompletion)
}

// MARK: - ProfileServiceImpl
final class OrderServiceImpl {
    private let networkClient: NetworkClient
    private let storage: OrderStorageProtocol

    init(networkClient: NetworkClient, storage: OrderStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }
}

// MARK: - ProfileService
extension OrderServiceImpl: OrderService {

    func loadOrder(completion: @escaping OrderCompletion) {
        if let order = storage.getOrder() {
            completion(.success(order))
            return
        }
        let request = OrderRequest()
        networkClient.send(request: request,
                           type: Order.self) { [weak storage] result in
            switch result {
            case .success(let order):
                storage?.saveOrder(order: order)
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateOrder(dto: String, completion: @escaping OrderCompletion) {
        let request = OrderPutRequest(dto: dto)
        networkClient.send(request: request,
                           type: Profile.self) { [weak self, storage] result in
            guard let self else { return }
            storage.removeOrder()
            switch result {
            case .success:
                self.loadOrder { result in
                    switch result {
                    case .success(let order):
                        completion(.success(order))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateOrder(nfts: [String], completion: @escaping OrderCompletion) {
        let dto = nfts.map {"nfts=\($0)"}.joined(separator: "&")
        let request = OrderPutRequest(dto: dto)
        networkClient.send(request: request,
                           type: Order.self) { [weak self, storage] result in
            guard let self else { return }
            storage.removeOrder()
            switch result {
            case .success:
                self.loadOrder { result in
                    switch result {
                    case .success(let order):
                        storage.saveOrder(order: order)
                        completion(.success(order))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
