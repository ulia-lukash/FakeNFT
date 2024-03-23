//
//  NftRequest.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import Foundation

struct GetNFTRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}

struct GetNFTsRequest: NetworkRequest {

    let page: Int

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft?page=\(page)&size=10")
    }
}
