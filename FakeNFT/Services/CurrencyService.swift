//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 25.02.2024.
//

import Foundation

typealias CurrenciesCompletion = (Result<[Currency], Error>) -> Void

protocol CurrenciesService {
    func loadCurrencies(completion: @escaping CurrenciesCompletion)
}

// MARK: - ProfileServiceImpl
final class CurrenciesServiceImpl {
    private let networkClient: NetworkClient
    private let storage: CurrenciesStorageProtocol

    init(networkClient: NetworkClient, storage: CurrenciesStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }
}

// MARK: - ProfileService
extension CurrenciesServiceImpl: CurrenciesService {

    func loadCurrencies(completion: @escaping CurrenciesCompletion) {
        if let currencies = storage.getCurrencies() {
            completion(.success(currencies))
            return
        }
        let request = GetCurrenciesRequest()
        networkClient.send(request: request,
                           type: [Currency].self) { [weak storage] result in
            switch result {
            case .success(let currencies):
                storage?.saveCurrencies(currencies)
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
