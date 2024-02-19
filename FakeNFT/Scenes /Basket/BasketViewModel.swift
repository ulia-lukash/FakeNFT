//
//  BasketViewModel.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 16.02.2024.
//

import Foundation
import ProgressHUD

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
    var nft: [Nft] { get }
    func sortButtonClicked()
    func sorting(with sortList: Filters)
    func loadNFTModels()
    //func updateOrder(with newNFTs: [String])
}

final class BasketViewModel: BasketViewModelProtocol {
    var onChange: (() -> Void)?
    var onSortButtonClicked: (() -> Void)?
    var counterNft: Int = 0
    var quantityNft: Float = 0
    
    private let storage: StorageManagerProtocol = StorageManager()
    
    private let service: BasketServiceProtocol
    
    private(set) var nft: [Nft] = [] {
        didSet {
            onChange?()
        }
    }
    
    init(service: BasketServiceProtocol = BasketService()) {
        self.service = service
    }
    
    private func loadingLastSort() {
        if let sortData = storage.string(forKey: .sort) {
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
        storage.set(sortList.rawValue, forKey: .sort)
    }
    
    func sortButtonClicked() {
        onSortButtonClicked?()
    }
    
//    func updateOrder(with newNFTs: [String]) {
//        service.updateOrder(with: newNFTs) { result in
//            switch result {
//            case .success:
//            case .failure:
//            }
//            ProgressHUD.mediaSize = 50
//            ProgressHUD.marginSize = 0
//            ProgressHUD.dismiss()
//        }
//        loadNFTModels()
//    }
    
    func loadNFTModels() {
        ProgressHUD.mediaSize = 50
        ProgressHUD.marginSize = 0
        ProgressHUD.show()
        service.loadOrder { result in
            switch result {
            case .success(let order):
                order.forEach { id in
                    self.service.loadNft(by: id) { models in
                        switch models {
                        case .success(let model):
                            self.nft.append(model)
                            self.loadingLastSort()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            ProgressHUD.dismiss()
        }
        loadingLastSort()
    }
}
