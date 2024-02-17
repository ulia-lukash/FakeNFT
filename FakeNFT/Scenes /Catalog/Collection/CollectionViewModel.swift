//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 14.02.2024.
//

import Foundation

final class CollectionViewModel {

    private let service = NftCollectionsService.shared
    private var nftCollectionServiceObserver: NSObjectProtocol?
    var onChange: (() -> Void)?

    private(set) var collection: NftCollection? {
            didSet {
                nftCollectionServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: NftCollectionsService.didChangeUserNotification,
                        object: nil,
                        queue: .main) { [weak self] _ in
                            guard let self = self else { return }
                            self.author = service.user
                        }
                guard let collection = self.collection else { return }
                service.fetchUser(withId: collection.author)
            }
        }

    private(set) var nfts: [Nft]? {
            didSet {
                guard let collection = collection, let nfts = nfts else { return }
                self.nfts = nfts.filter { collection.nfts.contains($0.id)}
                onChange?()
            }
        }

    private(set) var author: User? {
            didSet {
                nftCollectionServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: NftCollectionsService.didChangeNftsNotification,
                        object: nil,
                        queue: .main) { [weak self] _ in
                            guard let self = self else { return }
                            self.nfts = service.nfts
                        }
                guard let collection = self.collection else { return }
                service.fetchNfts()
            }
        }

    func getCollection(withId id: String) {
        nftCollectionServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftCollectionsService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.collection = service.collection
                }
        service.fetchCollection(withId: id)
    }
}
