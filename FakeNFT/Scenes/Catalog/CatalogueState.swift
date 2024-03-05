//
//  CatalogueState.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

enum CatalogueState {
    case initial
    case loading
    case update
    case failed(Error)
    case data([NftCollection])
}
