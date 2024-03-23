//
//  CollectionsRequest.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import Foundation
struct GetCollectionsRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
}
