//
//  MyNftRequest.swift
//  FakeNFT
//
//  Created by Григорий Машук on 20.02.24.
//

import Foundation

struct MyNftRequest: NetworkRequest {
    var page: Int
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/nft?page=\(page)&size=\(ApiConstants.pageSize)")
    }
}
