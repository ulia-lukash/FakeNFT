//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Григорий Машук on 14.02.24.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

