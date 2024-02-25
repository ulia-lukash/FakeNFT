//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 14.02.2024.
//

import Foundation

protocol CollectionViewModelProtocol: AnyObject {
    
    var onChange: (() -> Void)? { get set }
    var collection: NftCollection? { get }
    var nfts: [Nft] { get }
    func isLiked(nft nftId: UUID) -> Bool?
    func isInCart(nft nftId: UUID) -> Bool?
    func didTapLikeFor(nft id: UUID)
    func didTapCartFor(nft id: UUID)
    func getCollectionViewData(collectionId id: UUID)
    func clearData()}

final class CollectionViewModel: CollectionViewModelProtocol {
    
    static let didChangeNftsNotification = Notification.Name(rawValue: "Did load more Nfts")
    var onChange: (() -> Void)?
    private let queue = OperationQueue()
    private let profileService = ProfileService.shared
    private let orderService = OrderService.shared
    private let collectionService = NftCollectionService.shared
    private let nftService = NftService.shared
    
    private var nftCollectionServiceObserver: NSObjectProtocol?
    
    private(set) var collection: NftCollection?
    
    private (set) var profile: Profile?
    
    private (set) var nfts: [Nft] = []
    
    private(set) var order: Order? {
        didSet {
            onChange?()
        }
    }
    
    func getCollectionViewData(collectionId id: UUID) {
                
        DispatchQueue.main.async {
            self.nftCollectionServiceObserver = NotificationCenter.default
                .addObserver(
                    forName: NftCollectionService.didChangeNotification,
                    object: nil,
                    queue: .main) { [weak self] _ in
                        guard let self = self else { return }
                        self.collection = collectionService.collection
                        self.getProfile()
                    }
            let id = id.uuidString.lowercased()
            self.collectionService.fetchCollection(withId: id)
        }
        
    }
    
    func isLiked(nft nftId: UUID) -> Bool? {
        
        guard let profile = profile else { return false }
        return profile.likes.contains(nftId)
    }
    
    func isInCart(nft nftId: UUID) -> Bool? {
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
    
    private func fetchNfts() {
        guard let nfts = collection?.nfts else { return }
        
        self.nftCollectionServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftService.didChangeNftNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    guard let nft = nftService.nft else { return }
                    self.nfts.append(nft)
                    NotificationCenter.default.post(
                        name: CollectionViewModel.didChangeNftsNotification,
                        object: self,
                        userInfo: ["nfts": self.nfts] )
                }
        
        for nftId in nfts {
            DispatchQueue.main.async {
                let id = nftId.uuidString.lowercased()
                self.nftService.fetchNft(withId: id)
            }
        }
    }
    
    private func getOrder() {
        DispatchQueue.main.async {
            self.nftCollectionServiceObserver = NotificationCenter.default
                .addObserver(
                    forName: OrderService.didChangeOrderNotification,
                    object: nil,
                    queue: .main) { [weak self] _ in
                        guard let self = self else { return }
                        self.order = orderService.order
                        self.fetchNfts()
                    }
            self.orderService.fetchOrder()
        }
    }
    private func getProfile() {
        DispatchQueue.main.async {
            self.nftCollectionServiceObserver = NotificationCenter.default
                .addObserver(
                    forName: ProfileService.didChangeProfileNotification,
                    object: nil,
                    queue: .main) { [weak self] _ in
                        guard let self = self else { return }
                        self.profile = profileService.profile
                        getOrder()
                    }
            self.profileService.fetchProfile()
        }
    }
}
