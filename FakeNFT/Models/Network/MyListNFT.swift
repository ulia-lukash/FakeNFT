//
//  MyListNFT.swift
//  FakeNFT
//
//  Created by Григорий Машук on 19.02.24.
//

import Foundation

struct MyListNFT: Decodable {
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
