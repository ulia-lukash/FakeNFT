//
//  PUTOrderRequest.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 05.03.2024.
//

import Foundation

struct PutOrderRequest: NetworkRequest {
    var nfts: [String]
    var httpMethod: HttpMethod {.put}
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var dto: Encodable? {
        let nftString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
        return nftString
    }
}
