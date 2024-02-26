//
//  MyNftRequest.swift
//  FakeNFT
//
//  Created by Григорий Машук on 20.02.24.
//

import Foundation

struct MyNftRequest: NetworkRequest {
    var id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/nft/\(id)")
    }
}
