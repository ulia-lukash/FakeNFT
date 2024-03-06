//
//  Author.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 17.02.2024.
//

import Foundation

struct User {
    let name: String
    let website: URL?
    let id: String

    init(name: String, website: String, id: String) {
        self.name = name
        self.website = URL(string: website)
        self.id = id
    }
}
