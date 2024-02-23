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
    private let urlSession = URLSession.shared
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

    func changeOrderWith(_ nfts: [UUID]) {
        let nfts = nfts.map {$0.uuidString.lowercased()}
        let nftsString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
        let reqData = Data(nftsString.utf8)

        guard let request = makePutRequest(
            path: RequestConstants.orderFetchEndpoint,
            data: reqData) else { assertionFailure("Failed to make order put request")
            return
        }
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let _ = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {

                } else {
                    print(NetworkError.httpStatusCode(statusCode))
                }
            } else if let error = error {
                print(NetworkError.urlRequestError(error))
            } else {
                print(NetworkError.urlSessionError)
            }
        }
        task.resume()
    }
}
