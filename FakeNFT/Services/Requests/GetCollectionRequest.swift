//
//  CollectionRequest.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import Foundation

struct GetCollectionRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
    }
}
