//
//  GetOrderPaymentRequest.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 23.02.2024.
//

import Foundation

struct GetOrderPaymentRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(id)")
    }
    
    var httpMethod: HttpMethod
}
