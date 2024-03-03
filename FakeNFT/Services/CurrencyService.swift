//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 25.02.2024.
//

import Foundation

final class CurrencyService: RequestService {

    // MARK: - Public Properties

    static let shared = CurrencyService()
    static let didChangeCurrenciesNotification = Notification.Name(rawValue: "Did fetch curremcies")
    // MARK: - Private Properties

    private (set) var currencies: [Currency] = []
    private var task: URLSessionTask?
    private let defaults = UserDefaults.standard

    // MARK: - Public Methods

    func fetchCurrencies() {

        guard let request = makeGetRequest(path: RequestConstants.currenciesFetchEndpoint) else {
            return assertionFailure("Failed to make an NFT request")}

        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[Currency], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let currencies):
                self.mapCurrencies(currencies)
                NotificationCenter.default.post(
                    name: CurrencyService.didChangeCurrenciesNotification,
                    object: self,
                    userInfo: ["currencies": self.currencies] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    private func mapCurrencies(_ currencies: [Currency]) {
        currencies.forEach {
            self.currencies.append(Currency(id: $0.id, title: $0.title, name: $0.name, image: $0.image))
        }
    }
    
}
