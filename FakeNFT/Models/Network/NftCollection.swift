//
//  NftCollection.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 11.02.2024.
//

import Foundation

struct NftCollection: Codable {
    let name: String
    let cover: String
    let nfts: [UUID]
    let description: String
    let author: String
    let id: UUID

}
