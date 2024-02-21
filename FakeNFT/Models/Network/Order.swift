//
//  Order.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 17.02.2024.
//

import Foundation

struct Order: Codable {
    let nfts: [UUID]
    let id: String
}
