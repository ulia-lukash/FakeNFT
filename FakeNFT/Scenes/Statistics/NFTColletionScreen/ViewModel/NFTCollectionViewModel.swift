import Foundation

protocol NFTCollectionViewModelProtocol: AnyObject, NFTCellProtocol {
    var userNFTCollection: [NFT] { get }
    var onLoadingState: (() -> Void)? { get set }
    var onDataState: (() -> Void)? { get set }
    var onErrorState: ((ErrorModel) -> Void)? { get set }
    var onNFTCollectionChange: (() -> Void)? { get set }
    var currentUser: User { get }
    func viewDidLoad()
}

enum NFTCollectionViewModelDetailState {
    case initial, loading, failed(Error), data([NFTData])
}

final class NFTCollectionViewModel: NFTCollectionViewModelProtocol {
    var onLoadingState: (() -> Void)?
    var onDataState: (() -> Void)?
    var onErrorState: ((ErrorModel) -> Void)?
    var onNFTCollectionChange: (() -> Void)?

    var servicesAssembly: ServicesAssembly

    private(set) var userNFTCollection: [NFT] = [] {
        didSet {
            onNFTCollectionChange?()
        }
    }

    private(set) var currentUser: User

    private var currentProfile: ProfileData? {
        didSet {
            setLikesInfo(nftIds: currentProfile?.likes)
        }
    }

    private let NFTModel: NFTModelProtocol

    private var state = NFTCollectionViewModelDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(for model: NFTModelProtocol, user: User, servicesAssembly: ServicesAssembly) {
        NFTModel = model
        currentUser = user
        self.servicesAssembly = servicesAssembly
    }

    func viewDidLoad() {
        state = .loading
        updateNFTCollection()
        loadProfile()
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            onLoadingState?()
            loadNFTs()
            loadOrder()
        case .data(let nftsData):
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.onDataState?()
                self.NFTModel.saveNfts(nfts: nftsData)
                self.updateNFTCollection()
            }
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            onErrorState?(errorModel)
        }
    }

    private func setLikesInfo(nftIds: [String]?) {
        if let nftIds = nftIds {
            NFTModel.setLikesInfo(nftIds: nftIds)
        }
        updateNFTCollection()
    }

    private func loadNFTs() {
        let nfts = NFTModel.getUserNFTCollection()
        if !nfts.isEmpty {
            userNFTCollection = nfts
        }

        if currentUser.nfts.isEmpty {
            state = .data([])
            return
        }

        servicesAssembly.nftService.loadUserNfts(nftIDS: currentUser.nfts) { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.state = .data(nfts)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func loadProfile() {
        servicesAssembly.profileService.loadProfile(id: "1") { [weak self] result in
            switch result {
            case .success(let profile):
                self?.currentProfile = profile
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func updateLikesInfo() {
        servicesAssembly.profileService.setLikes(
            nfts: NFTModel.likedNfts
        ) { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.currentProfile = profile
                    self?.updateNFTCollection()
                }
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func loadOrder() {
        servicesAssembly.profileService.loadOrder { [weak self] result in
            switch result {
            case .success(let orderData):
                self?.updateCurrentOrder(orderData: orderData)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func updateOrderInfo() {
        servicesAssembly.profileService.setOrder(
            nfts: NFTModel.orderedNfts
        ) { [weak self] result in
            switch result {
            case .success(let orderData):
                self?.updateCurrentOrder(orderData: orderData)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func updateNFTCollection() {
        userNFTCollection = NFTModel.getUserNFTCollection()
    }

    private func updateCurrentOrder(orderData: OrderData) {
        DispatchQueue.main.async { [weak self] in
            self?.NFTModel.setCurrentOrder(nfts: orderData.nfts)
            self?.updateNFTCollection()
        }
    }
}

extension NFTCollectionViewModel: NFTCellProtocol {
    func basketButtonDidTap(nftId: String, isOrdered: Bool) {
        if isOrdered {
            NFTModel.saveCurrentOrderInfo(nfts: [nftId])
        } else {
            NFTModel.removeFromOrder(nft: [nftId])
        }
        updateOrderInfo()
    }

    func likeButtonDidTap(nftId: String, isLiked: Bool) {
        if isLiked {
            NFTModel.saveLikesInfo(nftIds: [nftId])
        } else {
            NFTModel.removeFromLiked(nftIds: [nftId])
        }
        updateLikesInfo()
    }
}

extension NFTCollectionViewModel {
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
