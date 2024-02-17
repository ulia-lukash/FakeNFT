//
//  NftIdGetModel.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 16.02.2024.
//

import Foundation

struct NftBasketModel: Decodable {
    let name: String
    let images: [URL]
    let rating: Int
    let price: Float
    let id: String
}
