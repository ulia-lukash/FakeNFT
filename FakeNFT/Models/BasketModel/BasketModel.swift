//
//  MocksBasket.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 16.02.2024.
//

import UIKit

final class BasketModel {
    static var mocksBasket = [
        Nft(name: "Melvin Yang", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Dominique/1.png")!], rating: 1, price: 12.78, id: ""),
        Nft(name: "Linnie Sanders", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/1.png")!], rating: 2, price: 40.59, id: ""),
        Nft(name: "Jody Rivers", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/1.png")!], rating: 5, price: 34.14, id: ""),
    ]
}
