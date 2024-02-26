//
//  OrderService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 21.02.2024.
//

import Foundation

final class OrderService: RequestService {

    // MARK: - Public Properties

    static let shared = OrderService()
    static let didChangeOrderNotification = Notification.Name(rawValue: "Did fetch ORDER")

    // MARK: - Private Properties

    private (set) var order: Order?
    private var task: URLSessionTask?
    private let defaults = UserDefaults.standard

    // MARK: - Public Methods

    func fetchOrder() {

        if task != nil { return }

        guard let request = makeGetRequest(path: RequestConstants.orderFetchEndpoint) else {
            return assertionFailure("Failed to make order request")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<Order, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = order
                NotificationCenter.default.post(
                    name: OrderService.didChangeOrderNotification,
                    object: self,
                    userInfo: ["order": self.order as Any] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
