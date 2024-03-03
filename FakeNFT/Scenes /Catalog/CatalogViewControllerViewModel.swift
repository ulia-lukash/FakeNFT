//
//  CatalogViewControllerViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 12.02.2024.
//

import Foundation

protocol CatalogViewModelProtocol: AnyObject {
    func getCollections()
    func collectionsNumber() -> Int
    func collectionsFilterByName()
    func collectionsFilterByNumber()
    var onChange: (() -> Void)? { get set }
    var collections: [NftCollection] { get }
}

protocol CatalogViewModelDelegateProtocol: AnyObject {
    func showError()
}

final class CatalogViewControllerViewModel: CatalogViewModelProtocol {

    private let delegate: CatalogViewModelDelegateProtocol
    private let service = NftCollectionService.shared
    private var nftCollectionsServiceObserver: NSObjectProtocol?
    private var nftCollectionsErrorServiceObserver: NSObjectProtocol?
    private let defaults = UserDefaults.standard

    var onChange: (() -> Void)?

    private(set) var collections: [NftCollection] = [] {
            didSet {
                onChange?()
            }
        }
    
    init(delegate: CatalogViewModelDelegateProtocol) {
        self.delegate = delegate
    }
    
    func getCollections() {
        nftCollectionsServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftCollectionService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.collections = service.collections
                }
        nftCollectionsErrorServiceObserver = NotificationCenter.default.addObserver(forName: NftCollectionService.errorFetchingData, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.delegate.showError()
        }
        service.fetchCollections()
    }

    func collectionsNumber() -> Int {
        collections.count
    }

    func collectionsFilterByName() {
        defaults.set(true, forKey: "ShouldFilterByName")
        collections.sort(by: {$0.name < $1.name})
    }

    func collectionsFilterByNumber() {
        defaults.removeObject(forKey: "ShouldFilterByName")
        collections.sort(by: {$0.nfts.count > $1.nfts.count})
    }
}
