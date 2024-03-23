//
//  GetCurrenciesRequest.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 23.02.2024.
//

import Foundation

struct GetCurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
