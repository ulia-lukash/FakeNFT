//
//  MyNftSortRequest.swift
//  FakeNFT
//
//  Created by Григорий Машук on 21.02.24.
//

import Foundation

struct MyNftSortRequest: NetworkRequest {
    var sort: SortState
    var page: Int
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/nft?sortBy=\(sort.rawValue)&order=asc&page=\(page)&size=\(ApiConstants.pageSize)")
    }
}
