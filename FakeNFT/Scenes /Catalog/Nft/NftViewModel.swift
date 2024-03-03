//
//  NftViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 25.02.2024.
//

import Foundation

protocol NftViewModelDelegateProtocol: AnyObject {
    func updateCollectionView(oldCount: Int, newCount: Int)
}
protocol NftViewModelProtocol: AnyObject {
    var delegate: (NftViewModelDelegateProtocol)? { get set }
    var onChange: (() -> Void)? { get set }
    func getNft(withId id: UUID)
    var currencies: [Currency] { get }
    var nft: Nft? { get }
    var nfts: [Nft]? { get }
    func isLiked(nft nftId: UUID) -> Bool
    func isInCart(nft nftId: UUID) -> Bool
    func didTapLikeFor(nft id: UUID)
    func didTapCartFor(nft id: UUID)
    func fetchMoreNfts()
}
final class NftViewModel: NftViewModelProtocol {
    
    weak var delegate: NftViewModelDelegateProtocol?
    var onChange: (() -> Void)?
    
    private var currencyServiceObserver: NSObjectProtocol?
    private var nftServiceObserver: NSObjectProtocol?
    private var profileServiceObserver: NSObjectProtocol?
    private var orderServiceObserver: NSObjectProtocol?
    
    private let currencyService = CurrencyService.shared
    private let nftService = NftService.shared
    private let profileService = ProfileService.shared
    private let orderService = OrderService.shared
    
    private(set) var profile: Profile?
    private(set) var order: Order?
    private(set) var nft: Nft?
    private(set) var nfts: [Nft]?
    private var likes: [UUID] = []
    private var cart: [UUID] = []
    
    private(set) var currencies: [Currency] = [] {
        didSet {
            onChange?()
        }
    }
    
    func getNft(withId id: UUID) {
        self.nftServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftService.didGetNftNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.nft = nftService.nft
                    self.getCurrencies()
                    self.getProfile()
                    self.getOrder()
                }
        let id = id.uuidString.lowercased()
        nftService.fetchNft(withId: id)
    }
    
    func isLiked(nft nftId: UUID) -> Bool {
        
        guard let profile = profile else { return false }
        return profile.likes.contains(nftId)
    }
    
    func isInCart(nft nftId: UUID) -> Bool {
        guard let order = order else { return false }
        return order.nfts.contains(nftId)
    }
    
    func didTapLikeFor(nft id: UUID) {
        if likes.contains(id) {
            likes = likes.filter { $0 != id}
        } else {
            likes.append(id)
        }
        profileService.putData(likes, url: RequestConstants.profileFetchEndpoint, isLikes: true)
    }
    
    func didTapCartFor(nft id: UUID) {
        if cart.contains(id) {
            cart = cart.filter { $0 != id}
        } else {
            cart.append(id)
        }
        orderService.putData(cart, url: RequestConstants.orderFetchEndpoint, isLikes: false)
    }
    
    private func getCurrencies() {
        self.currencyServiceObserver = NotificationCenter.default
            .addObserver(
                forName: CurrencyService.didChangeCurrenciesNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.currencies = currencyService.currencies
                    self.fetchMoreNfts()
                }
        currencyService.fetchCurrencies()
    }
    
    private func getProfile() {
        self.profileServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileService.didChangeProfileNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.profile = profileService.profile
                    self.likes = profile?.likes ?? []
                }
        profileService.fetchProfile()
    }
    
    private func getOrder() {
        self.orderServiceObserver = NotificationCenter.default
            .addObserver(
                forName: OrderService.didChangeOrderNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.order = orderService.order
                    self.cart = order?.nfts ?? []
                }
        orderService.fetchOrder()
    }
    
    func fetchMoreNfts() {
        self.nftServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftService.didChangeNftsNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateCollectionView()
                }
        nftService.fetchNftsNextPage()
    }
    private func updateCollectionView() {
        
        let oldCount = nfts?.count ?? 0
        let newCount = nftService.nfts.count
        nfts = nftService.nfts
        delegate?.updateCollectionView(oldCount: oldCount, newCount: newCount)
    }
}
