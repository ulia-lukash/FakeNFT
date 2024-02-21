//
//  CatalogViewControllerViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 12.02.2024.
//

import Foundation

final class CatalogViewControllerViewModel {

    private let service = NftCollectionsService.shared
    private var nftCollectionsServiceObserver: NSObjectProtocol?
    private let defaults = UserDefaults.standard
    var onChange: (() -> Void)?

    private(set) var collections: [NftCollection] = [] {
            didSet {
                onChange?()
            }
        }

    func getCollections() {
        nftCollectionsServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftCollectionsService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.collections = service.collections
                }
        service.fetchCollections()
    }

    func collectionsNumber() -> Int {

        collections.count
    }

    func collectionsFilterdByName() {
        defaults.set(true, forKey: "ShouldFilterByName")
        collections.sort(by: {$0.name < $1.name})
    }

    func collectionsFileterByNumber() {
        defaults.removeObject(forKey: "ShouldFilterByName")
        collections.sort(by: {$0.nfts.count > $1.nfts.count})
    }
}
