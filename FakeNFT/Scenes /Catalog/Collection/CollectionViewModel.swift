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
                        forName: NftCollectionsService.didChangeProfileNotification,
                        object: nil,
                        queue: .main) { [weak self] _ in
                            guard let self = self else { return }
                            self.profile = service.profile
                        }
                service.fetchProfile()

                guard let collection = collection else { return }
                for nft in collection.nfts {
                    self.fetchNft(withId: nft)
                }
            }
        }

    private (set) var profile: Profile? {
        didSet {
            nftCollectionServiceObserver = NotificationCenter.default
                .addObserver(
                    forName: NftCollectionsService.didChangeOrderNotification,
                    object: nil,
                    queue: .main) { [weak self] _ in
                        guard let self = self else { return }
                        self.order = service.order
                    }
            service.fetchOrder()
        }
    }

    private(set) var order: Order? {
        didSet {
            onChange?()
        }
    }

    private (set) var nfts: [Nft] = []

    func getCollection(withId id: UUID) {
        nftCollectionServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftCollectionsService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.collection = service.collection
                }
        let id = id.uuidString.lowercased()
        service.fetchCollection(withId: id)
    }

    func fetchNft(withId id: UUID) {
        nftCollectionServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftCollectionsService.didChangeNftsNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.nfts = service.nfts
                }
        let id = id.uuidString.lowercased()
        self.service.fetchNft(withId: id)
    }

    func isLiked(nft nftId: UUID) -> Bool? {

        guard let profile = profile else { return false }
        return profile.likes.contains(nftId)
    }

    func isInBasket(nft nftId: UUID) -> Bool? {
        guard let order = order else { return false }
        return order.nfts.contains(nftId)
    }

    func didTapLikeFor(nft id: UUID) {

    }

    func didTapCartFor(nft id: UUID) {

    }

    func clearData() {
        service.clearData()
    }
}
