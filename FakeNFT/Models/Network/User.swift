//
//  Author.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 17.02.2024.
//

import Foundation

struct User {
    let name: String
    let avatar: URL?
    let description: String
    let website: URL?
    let nfts: [String]
    let rating: String
    let id: String

    init(name: String, avatar: String, description: String, website: String, nfts: [String], rating: String, id: String) {
        self.name = name
        self.avatar = URL(string: avatar)
        self.description = description
        self.website = URL(string: website)
        self.nfts = nfts
        self.rating = rating
        self.id = id
    }
}
