import Foundation

protocol UserInfoViewModelProtocol: AnyObject {
    var onNFTCollectionButtonTap: (() -> Void)? { get set }
    var currentUser: User { get }
    func nftCollectionButtonDidTap()
}

final class UserInfoViewModel: UserInfoViewModelProtocol {
    var onNFTCollectionButtonTap: (() -> Void)?

    private(set) var currentUser: User

    init(for currentUser: User) {
        self.currentUser = currentUser
    }

    func nftCollectionButtonDidTap() {
        onNFTCollectionButtonTap?()
    }
}
