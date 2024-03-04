//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import Foundation

protocol CollectionViewModelProtocol: AnyObject {

    var collection: NftCollection? { get }
    var nfts: [Nft]? { get }
    func setStateLoading()
    func isLiked(nft nftId: String) -> Bool?
    func isInCart(nft nftId: String) -> Bool?
    func didTapLikeFor(nft id: String)
    func didTapCartFor(nft id: String)
}

final class CollectionViewModel: CollectionViewModelProtocol {

    @Observable<CollectionState> private(set) var state: CollectionState = .initial

    private let collectionService: CollectionService
    private let nftService: NftService
    private let profileService: ProfileService
    private let orderService: OrderService

    private(set) var collection: NftCollection?
    private(set) var profile: Profile?
    private(set) var order: Order?
    private(set) var nfts: [Nft]?

    private var likes: [String] = []
    private var cart: [String] = []

    init(collectionService: CollectionService, nftService: NftService, profileService: ProfileService, orderService: OrderService) {
        self.collectionService = collectionService
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
    }

    func setStateLoading() {
        self.state = .loading
    }

    func loadCollection(withId id: String) {
        collectionService.loadCollection(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let collection):
                    self.saveCollection(collection)
                    self.loadOrder()
                    self.loadProfile()
                    self.loadNFT()
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }

    private func loadOrder() {
        orderService.loadOrder { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let order):
                    self.saveOrder(order)
                    self.cart = order.nfts
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }

    private func loadProfile() {
        profileService.loadProfile { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.saveProfile(profile)
                    self.likes = profile.likes
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }

    func loadNFT() {
        guard let collection else { return }
        nftService.loadNfts(withIds: collection.nfts) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let nfts):
                    self.saveNfts(nfts)
                    self.state = .data(self.collection!)
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }

    func makeErrorModel(error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = ConstLocalizable.errorNetwork
        default:
            message = ConstLocalizable.errorUnknown
        }
        let actionText = ConstLocalizable.errorRepeat
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            guard let self else { return }
            self.state = .loading
        }
    }

    private func saveCollection(_ collection: NftCollection) {
        self.collection = collection
    }

    private func saveOrder(_ order: Order) {
        self.order = order
    }

    private func saveProfile(_ profile: Profile) {
        self.profile = profile
    }

    private func saveNft(_ nft: Nft) {
        self.nfts?.append(nft)
    }

    func isLiked(nft nftId: String) -> Bool? {

        guard let profile = profile else { return false }
        return profile.likes.contains(nftId)
    }

    func isInCart(nft nftId: String) -> Bool? {
        guard let order = order else { return false }
        return order.nfts.contains(nftId)
    }

    func didTapLikeFor(nft id: String) {

        if likes.contains(id) {
            likes = likes.filter { $0 != id}
        } else {
            likes.append(id)
        }
        profileService.updateProfile(likes: likes) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let profile):
                    self.saveProfile(profile)
                    guard let collection = self.collection else { return }
                    self.state = .data(collection)
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }

    func didTapCartFor(nft id: String) {
        if cart.contains(id) {
            cart = cart.filter { $0 != id}
        } else {
            cart.append(id)
        }
        orderService.updateOrder(nfts: cart) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let order):
                    self.saveOrder(order)
                    guard let collection = self.collection else { return }
                    self.state = .data(collection)
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }

    private func saveNfts(_ nfts: [Nft]) {
        self.nfts = nfts.sorted { $0.name < $1.name}
    }
}
