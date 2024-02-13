//
//  NftCollection.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 11.02.2024.
//

import Foundation

struct NftCollection: Codable {
    let createdAt: Date?
    let name: String
    let cover: URL
    let nfts: [String]
    let description: String
    let author: String
    let id: String

    init(createdAt: String, name: String, cover: String, nfts: [String], description: String, author: String, id: String) {

        let date = DateFormatter.defaultDateFormatter.date(from: createdAt)!

        let coverUrl = URL(string: cover)!

        self.createdAt = date
        self.name = name
        self.cover = coverUrl
        self.nfts = nfts
        self.description = description
        self.author = author
        self.id = id
    }
}
