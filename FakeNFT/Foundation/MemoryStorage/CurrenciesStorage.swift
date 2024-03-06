//
//  CurrenciesStorage.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import Foundation

protocol CurrenciesStorageProtocol: AnyObject {
    func saveCurrencies(_ currencies: [Currency])
    func getCurrencies() -> [Currency]?
}

final class CurrenciesStorageImpl {
    private var storage: [Currency]?
    private let syncQueue = DispatchQueue(label: "sync-currency-queue")
}

extension CurrenciesStorageImpl: CurrenciesStorageProtocol {
    func saveCurrencies(_ currencies: [Currency]) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            self.storage = currencies
        }
    }

    func getCurrencies() -> [Currency]? {
        syncQueue.sync { [weak self] in
            guard let self else { return nil }
            return self.storage
        }
    }
}
