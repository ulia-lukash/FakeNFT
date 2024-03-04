//
//  ProfilePutRequest.swift
//  FakeNFT
//
//  Created by Григорий Машук on 20.02.24.
//

import Foundation

struct ProfilePutRequest: NetworkRequest {
    var httpMethod: HttpMethod { .put }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var dto: Encodable?
}
