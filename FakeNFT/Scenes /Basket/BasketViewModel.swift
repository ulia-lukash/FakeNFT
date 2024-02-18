//
//  BasketViewModel.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 16.02.2024.
//

import Foundation

protocol BasketViewModelProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onSortButtonClicked: (() -> Void)? { get set }
    var counterNft: Int { get set }
    var quantityNft: Float { get set }
    var nft: [NftBasketModel] { get }
    func sortButtonClicked()
}

final class BasketViewModel: BasketViewModelProtocol {
    var onChange: (() -> Void)?
    var onSortButtonClicked: (() -> Void)?
    var counterNft: Int = 0
    var quantityNft: Float = 0
    
    private let basketModel: BasketModel
    
    private(set) var nft: [NftBasketModel] {
        didSet {
            onChange?()
        }
    }
    
    init(for model: BasketModel) {
        basketModel = model
        nft = BasketModel.mocksBasket
    }
    
    func sortButtonClicked() {
        onSortButtonClicked?()
    }
    
    
}
