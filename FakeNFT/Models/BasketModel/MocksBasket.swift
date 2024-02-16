//
//  MocksBasket.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 16.02.2024.
//

import UIKit

struct NftModelBasket {
    let name: String
    let image: UIImage
    let rating: Int
    let price: Float
    let id: UUID
}

struct MocksBasket {
    static var nftArray = [
        NftModelBasket(name: "April", image: UIImage(named: "mockAprilCard")!, rating: 1, price: 1.78, id: UUID()),
        NftModelBasket(name: "Greena", image: UIImage(named: "mockGreenaCard")!, rating: 3, price: 1.78, id: UUID()),
        NftModelBasket(name: "Spring", image: UIImage(named: "mockSpringCard")!, rating: 5, price: 1.78, id: UUID()),
    ]
}
