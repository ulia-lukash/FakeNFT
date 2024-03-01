import Foundation

protocol NFTCollectionViewModelProtocol: AnyObject {
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

    private var currentProfile: ProfileData?

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
        userNFTCollection = NFTModel.getUserNFTCollection(nftIDs: currentUser.nfts)
        servicesAssembly.profileService.loadProfile(id: "1") { [weak self] result in
            switch result {
            case .success(let profile):
                self?.currentProfile = profile
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            onLoadingState?()
            loadNFTs()
        case .data(let nftsData):
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.onDataState?()
                self.NFTModel.saveNfts(nfts: nftsData)
                self.userNFTCollection = self.NFTModel.getUserNFTCollection(nftIDs: currentUser.nfts)
            }
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            onErrorState?(errorModel)
        }
    }

    private func loadNFTs() {
        let nfts = NFTModel.getUserNFTCollection(nftIDs: currentUser.nfts)
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
