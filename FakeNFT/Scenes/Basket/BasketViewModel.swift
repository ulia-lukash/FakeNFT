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
    case error
}

protocol BasketViewModelProtocol: AnyObject {
    var onChange: ((String, String) -> Void)? { get set }
    var onLoad: ((Bool) -> Void)? { get set }
    var onSortButtonClicked: (() -> Void)? { get set }
    var nftCount: String { get }
    var nftQuantity: String { get }
    var nftItems: [Nft] { get }
    func sortButtonClicked()
    func sortItems(with sortList: Filters)
    func loadNftData()
    func deleteNft(index: String)
    func deleteAllNft()
}

final class BasketViewModel: BasketViewModelProtocol {
    
    // MARK: - Public properties:
    
    var onChange: ((String, String) -> Void)?
    var onLoad: ((Bool) -> Void)?
    var onSortButtonClicked: (() -> Void)?
    var nftCount: String {
        return "\(nftItems.count) NFT"
    }
    var nftQuantity: String {
        let totalNftPrice = nftItems.reduce(0) { $0 + $1.price }
        let formatterPrice = String(format: "%.2f", totalNftPrice).replacingOccurrences(of: ".", with: ",")
        return "\(formatterPrice) ETH"
    }
    
    // MARK: - Private properties:
    
    private let service: BasketServiceProtocol
    private let storage: StorageManagerProtocol
    
    private(set) var nftItems: [Nft] = [] {
        didSet {
            onChange?(nftCount, nftQuantity)
        }
    }
    
    // MARK: - Initializers
    
    init(service: BasketServiceProtocol, storage: StorageManagerProtocol) {
        self.service = service
        self.storage = storage
    }
    
    // MARK: - Public Methods
    
    func sortItems(with sortList: Filters) {
        onLoad?(true)
        switch sortList {
        case .price:
            nftItems = nftItems.sorted { $0.price > $1.price }
        case .rating:
            nftItems = nftItems.sorted { $0.rating > $1.rating }
        case .name:
            nftItems = nftItems.sorted { $0.name < $1.name }
        case .error:
            print("error by sorting")
        }
        storage.set(sortList.rawValue, forKey: .sort)
        onLoad?(false)
    }
    
    func sortButtonClicked() {
        onSortButtonClicked?()
    }
    
    func deleteNft(index: String) {
        onLoad?(true)
        nftItems.removeAll(where: { $0.id == index })
        onLoad?(false)
        updateOrder()
    }
    
    func loadNftData() {
        onLoad?(true)
        var arrayWithNft: [Nft] = []
        let dispatch = DispatchGroup()
        service.loadByOrders { result in
            switch result {
            case .success(let order):
                for id in order {
                    dispatch.enter()
                    self.service.loadByNft(by: id) { models in
                        switch models {
                        case .success(let model):
                            arrayWithNft.append(model)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        dispatch.leave()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            dispatch.notify(queue: .main) {
                let filterNfts = self.sortingArrayFromServer(arrayWithNft)
                self.nftItems = filterNfts
                self.onLoad?(false)
            }
        }
    }
    
    func deleteAllNft() {
        onLoad?(true)
        nftItems = []
        let arrayIdString = nftItems.map({ $0.id })
        service.updateByOrders(with: arrayIdString) { result in
            switch result {
            case .success: break
            case .failure: break
            }
        }
        onLoad?(false)
    }
    
    // MARK: - Private Methods
    
    private func loadingLastSort() {
        if let sortData = storage.string(forKey: .sort) {
            if let sortValue = Filters(rawValue: sortData) {
                sortItems(with: sortValue)
            }
        }
    }
    
    private func sortingArrayFromServer(_ array: [Nft]) -> [Nft] {
        var sortedArray = array
        var sortedType: Filters
        if let sortData = storage.string(forKey: .sort) {
            let sortValue = Filters(rawValue: sortData)
            sortedType = sortValue ?? .error
            switch sortedType {
            case .price:
                sortedArray = sortedArray.sorted { $0.price > $1.price }
            case .rating:
                sortedArray = sortedArray.sorted { $0.rating > $1.rating }
            case .name:
                sortedArray = sortedArray.sorted { $0.name < $1.name }
            case .error:
                print("error by sortedArray")
            }
        }
        return sortedArray
    }
    
    private func updateOrder() {
        let arrayIdString = nftItems.map({ $0.id })
        service.updateByOrders(with: arrayIdString) { result in
            switch result {
            case .success: break
            case .failure: break
            }
        }
    }
}
