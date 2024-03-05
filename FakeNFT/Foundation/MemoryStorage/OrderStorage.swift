//
//  OrderStorage.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import Foundation

protocol OrderStorageProtocol: AnyObject {
    func saveOrder(order: Order)
    func getOrder() -> Order?
    func removeOrder()
}

final class OrderStorageImpl {
    private var storage: Order?
    private let syncQueue = DispatchQueue(label: "sync-order-queue")
}

extension OrderStorageImpl: OrderStorageProtocol {
    func saveOrder(order: Order) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            self.storage = order
        }
    }

    func getOrder() -> Order? {
        syncQueue.sync { [weak self] in
            guard let self else { return nil }
            return self.storage
        }
    }

    func removeOrder() {
        syncQueue.sync { [weak self] in
            guard let self else { return }
            self.storage = nil
        }
    }
}
