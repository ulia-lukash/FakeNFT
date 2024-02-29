import Foundation

protocol UserInfoViewModelProtocol: AnyObject {
    var onNFTCollectionButtonTap: (() -> Void)? { get set }
    var onUserWebsiteButtonTap: (() -> Void)? { get set }
    var currentUser: User { get }
    func nftCollectionButtonDidTap()
    func userWebsiteButtonDidTap()
}

final class UserInfoViewModel: UserInfoViewModelProtocol {
    var onNFTCollectionButtonTap: (() -> Void)?
    var onUserWebsiteButtonTap: (() -> Void)?

    private(set) var currentUser: User

    init(for currentUser: User) {
        self.currentUser = currentUser
    }

    func nftCollectionButtonDidTap() {
        onNFTCollectionButtonTap?()
    }

    func userWebsiteButtonDidTap() {
        onUserWebsiteButtonTap?()
    }
}
