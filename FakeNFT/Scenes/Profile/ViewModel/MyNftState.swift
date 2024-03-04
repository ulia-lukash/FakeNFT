//
//  MyNftState.swift
//  FakeNFT
//
//  Created by Григорий Машук on 19.02.24.
//

import Foundation

enum MyNftState {
    case initial
    case loading
    case update
    case failed(Error)
    case data
}
