//
//  BasketViewModel.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 16.02.2024.
//

import Foundation

enum Filters: String {
    case price
    case rating
    case name
}

protocol BasketViewModelProtocol: AnyObject {
    var onChange: (() -> Void)? { get set }
    var onSortButtonClicked: (() -> Void)? { get set }
    var counterNft: Int { get set }
    var quantityNft: Float { get set }
    var nft: [NftBasketModel] { get }
    func sortButtonClicked()
    func sorting(with sortList: Filters)
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
        loadingLastSort()
    }
    
    private func loadingLastSort() {
        if let sortData = UserDefaults.standard.string(forKey: "sortingKey") {
            if let sortValue = Filters(rawValue: sortData) {
                sorting(with: sortValue)
            }
        }
    }
    
    func sorting(with sortList: Filters) {
        switch sortList {
        case .price:
            nft = nft.sorted { $0.price > $1.price }
        case .rating:
            nft = nft.sorted { $0.rating > $1.rating }
        case .name:
            nft = nft.sorted { $0.name < $1.name }
        }
        UserDefaults.standard.set(sortList.rawValue, forKey: "sortingKey")
    }
    
    func sortButtonClicked() {
        onSortButtonClicked?()
    }
    
}
