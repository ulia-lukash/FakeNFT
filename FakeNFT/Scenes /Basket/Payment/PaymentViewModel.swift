//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 22.02.2024.
//

import Foundation

protocol PaymentViewModelProtocol {
    var onChange: (() -> Void)? { get set }
    var onLoad: ((Bool) -> Void)? { get set }
    var currency: [CurrenciesModel] { get }
    var idCurrency: String { get set }
    var currencyName: String { get set }
    var checkBool: Bool { get set }
    func loadCurrency()
    func paymentAttempt()
}

final class PaymentViewModel: PaymentViewModelProtocol {
    
    // MARK: - Public properties:
    
    var onChange: (() -> Void)?
    var onLoad: ((Bool) -> Void)?
    var idCurrency: String = ""
    var currencyName: String = ""
    var checkBool: Bool = false
    
    // MARK: - Private properties:
    
    private let service: PaymentServiceProtocol
    
    private(set) var currency: [CurrenciesModel] = [] {
        didSet {
            onChange?()
        }
    }
    
    // MARK: - Initializers
    
    init(service: PaymentServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Public Methods
    
    func loadCurrency() {
        service.loadByPayment { result in
            switch result {
            case .success(let arrayPay):
                DispatchQueue.main.async {
                    self.currency = arrayPay
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func paymentAttempt() {
        onLoad?(true)
        var stubBool: Bool?
        let dispatch = DispatchGroup()
        dispatch.enter()
        service.loadByOrderPayment(by: idCurrency) { result in
            switch result {
            case .success(let model):
                    if model.success == true, model.id == self.currencyName {
                        stubBool = true
                    } else {
                        stubBool = false
                    }
            case .failure(let error):
                print(error.localizedDescription)
                stubBool = false
            }
            dispatch.leave()
            dispatch.notify(queue: .main) {
                guard let stubBool else { return }
                self.checkBool = stubBool
                self.onLoad?(false)
            }
        }
    }
}


