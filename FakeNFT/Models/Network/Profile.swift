//
//  Profile.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 17.02.2024.
//

import Foundation

struct Profile: Codable {
    let nfts: [UUID]
    let likes: [UUID]
    let id: String
}
