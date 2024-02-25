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
    var willChangeNfts: (() -> Void)? { get set }
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
    var willChangeNfts: (() -> Void)?
    
    private var currencyServiceObserver: NSObjectProtocol?
    private var nftServiceObserver: NSObjectProtocol?
    private var profileServiceObserver: NSObjectProtocol?
    private var orderServiceObserver: NSObjectProtocol?
    
    private let currencyService = CurrencyService.shared
    private let nftService = NftService.shared
    private let profileService = ProfileService.shared
    private let orderService = OrderService.shared
    
    private(set) var profile: Profile?
    private(set) var order: Order? {
        didSet {
            onChange?()
        }
    }
    private(set) var nft: Nft?
    private(set) var nfts: [Nft]?
    private(set) var currencies: [Currency] = []
    
    func getNft(withId id: UUID) {
        self.nftServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftService.didChangeNftNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.nft = nftService.nft
                    self.getCurrencies()
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
    
    private func getCurrencies() {
        self.currencyServiceObserver = NotificationCenter.default
            .addObserver(
                forName: CurrencyService.didChangeCurrenciesNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.currencies = currencyService.currencies
                    self.getProfile()
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
                    self.getOrder()
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
                    self.fetchMoreNfts()
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
