//
//  PaymentService.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 23.02.2024.
//

import Foundation

typealias PaymentCompletion = (Result<[CurrenciesModel], Error>) -> Void
typealias OrderPayment = (Result<PaymentCurrency, Error>) -> Void

protocol PaymentServiceProtocol {
    func loadByPayment(completion: @escaping PaymentCompletion)
    func loadByOrderPayment(by id: String, completion: @escaping OrderPayment)
}

final class PaymentService: PaymentServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadByPayment(completion: @escaping PaymentCompletion) {
        let request = GetCurrenciesRequest()
        networkClient.send(request: request, type: [CurrenciesModel].self) { result in
            switch result {
            case .success(let pay):
                completion(.success(pay))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadByOrderPayment(by id: String, completion: @escaping OrderPayment) {
        let request = GetOrderPaymentRequest(id: id)
        networkClient.send(request: request, type: PaymentCurrency.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
