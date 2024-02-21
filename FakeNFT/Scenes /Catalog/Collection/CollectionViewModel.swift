//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 14.02.2024.
//

import Foundation

protocol CollectionViewModelProtocol: AnyObject {
    func clearData()
    var onChange: (() -> Void)? { get set }
    var onLoadNft: (() -> Void)? { get set }
    var collection: NftCollection? { get }
    var nfts: [Nft] { get }
    func isLiked(nft nftId: UUID) -> Bool?
    func isInBasket(nft nftId: UUID) -> Bool?
    func didTapLikeFor(nft id: UUID)
    func didTapCartFor(nft id: UUID)
    func getCollection(withId id: UUID)
}

final class CollectionViewModel: CollectionViewModelProtocol {

    private let profileService = ProfileService.shared
    private let orderService = OrderService.shared
    private let collectionService = NftCollectionService.shared
    private let nftService = NftService.shared

    private var nftCollectionServiceObserver: NSObjectProtocol?
    var onChange: (() -> Void)?
    var onLoadNft: (() -> Void)?

    private(set) var collection: NftCollection? {
            didSet {
                nftCollectionServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ProfileService.didChangeProfileNotification,
                        object: nil,
                        queue: .main) { [weak self] _ in
                            guard let self = self else { return }
                            self.profile = profileService.profile
                        }
                profileService.fetchProfile()

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
                    forName: OrderService.didChangeOrderNotification,
                    object: nil,
                    queue: .main) { [weak self] _ in
                        guard let self = self else { return }
                        self.order = orderService.order
                    }
            orderService.fetchOrder()
        }
    }

    private(set) var order: Order? {
        didSet {
            onChange?()
        }
    }

    private (set) var nfts: [Nft] = [] {
        didSet {
            onLoadNft?()
        }
    }

    func getCollection(withId id: UUID) {
        nftCollectionServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftCollectionService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.collection = collectionService.collection
                }
        let id = id.uuidString.lowercased()
        collectionService.fetchCollection(withId: id)
    }

    func fetchNft(withId id: UUID) {
        nftCollectionServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftService.didChangeNftsNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.nfts = nftService.nfts
                }
        let id = id.uuidString.lowercased()
        nftService.fetchNft(withId: id)
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
        guard let profile = self.profile else { return }
        var likes: [UUID] = []
        if profile.likes.contains(id) {
            likes = profile.likes.filter { $0 != id}
        } else {
            likes = profile.likes
            likes.append(id)
        }
        profileService.changeLikesWith(likes)
    }

    func didTapCartFor(nft id: UUID) {
        guard let order = self.order else { return }
        var nfts: [UUID] = []
        if order.nfts.contains(id) {
            nfts = order.nfts.filter { $0 != id}
        } else {
            nfts = order.nfts
            nfts.append(id)
        }
        orderService.changeOrderWith(nfts)
    }

    func clearData() {
        nftService.clearData()
    }
}
