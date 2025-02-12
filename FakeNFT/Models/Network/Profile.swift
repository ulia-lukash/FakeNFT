//
//  Profile.swift
//  FakeNFT
//
//  Created by Григорий Машук on 12.02.24.
//

import Foundation

struct Profile: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
