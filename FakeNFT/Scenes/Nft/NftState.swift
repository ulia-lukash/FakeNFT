//
//  NftState.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import Foundation

enum NftState {
    case initial
    case loading
    case update
    case failed(Error)
    case data(Nft)
}
