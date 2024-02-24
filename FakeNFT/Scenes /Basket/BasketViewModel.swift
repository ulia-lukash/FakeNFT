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
    var onChange: (() -> Void)? { get set }
    var onLoad: ((Bool) -> Void)? { get set }
    var onSortButtonClicked: (() -> Void)? { get set }
    var counterNft: Int { get set }
    var quantityNft: Float { get set }
    var nft: [Nft] { get }
    func sortButtonClicked()
    func sorting(with sortList: Filters)
    func loadNftData()
    func deleteNft(index: String)
    func deleteAllNft()
}

final class BasketViewModel: BasketViewModelProtocol {
    
    // MARK: - Public properties:
    
    var onChange: (() -> Void)?
    var onLoad: ((Bool) -> Void)?
    var onSortButtonClicked: (() -> Void)?
    var counterNft: Int = 0
    var quantityNft: Float = 0
    
    // MARK: - Private properties:
    
    private let service: BasketServiceProtocol
    private let storage: StorageManagerProtocol
    
    private(set) var nft: [Nft] = [] {
        didSet {
            onChange?()
        }
    }
    
    // MARK: - Initializers
    
    init(service: BasketServiceProtocol, storage: StorageManagerProtocol) {
        self.service = service
        self.storage = storage
    }
    
    // MARK: - Public Methods
    
    func sorting(with sortList: Filters) {
        onLoad?(true)
        switch sortList {
        case .price:
            nft = nft.sorted { $0.price > $1.price }
        case .rating:
            nft = nft.sorted { $0.rating > $1.rating }
        case .name:
            nft = nft.sorted { $0.name < $1.name }
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
        nft.removeAll(where: { $0.id == index })
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
                self.nft = filterNfts
                self.onLoad?(false)
            }
        }
    }
    
    func deleteAllNft() {
        onLoad?(true)
        nft = []
        let arrayIdString = nft.map( { $0.id } )
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
                sorting(with: sortValue)
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
        let arrayIdString = nft.map( { $0.id } )
        service.updateByOrders(with: arrayIdString) { result in
            switch result {
            case .success: break
            case .failure: break
            }
        }
    }
}
