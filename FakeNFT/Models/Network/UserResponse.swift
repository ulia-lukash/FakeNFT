//
//  UserResponse.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 17.02.2024.
//

import Foundation

struct UserResponse: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
