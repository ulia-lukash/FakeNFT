import Foundation

protocol UserInfoViewModelProtocol: AnyObject {
    var onNFTCollectionButtonTap: (() -> Void)? { get set }
    func nftCollectionButtonDidTap()
}

final class UserInfoViewModel: UserInfoViewModelProtocol {
    var onNFTCollectionButtonTap: (() -> Void)?

    func nftCollectionButtonDidTap() {
        onNFTCollectionButtonTap?()
    }
}
