import Foundation

protocol RatingViewModelProtocol: AnyObject {
    var onSortButtonTap: (() -> Void)? { get set }
    var onUsersListChange: (() -> Void)? { get set }
    var onUserProfileDidTap: ((User) -> Void)? { get set }
    var allUsers: [User] { get }
    func sortButtonDidTap()
    func sortByNameDidTap()
    func sortByRatingDidTap()
    func userProfileDidTap(withIndex indexPath: IndexPath)
}

final class RatingViewModel: RatingViewModelProtocol {
    var onSortButtonTap: (() -> Void)?
    var onUsersListChange: (() -> Void)?
    var onUserProfileDidTap: ((User) -> Void)?

    private(set) var allUsers: [User] = [] {
        didSet {
            onUsersListChange?()
        }
    }

    private let userModel: RatingModel

    init(for model: RatingModel) {
        userModel = model
        allUsers = userModel.getUsers()
    }

    func sortButtonDidTap() {
        onSortButtonTap?()
    }

    func sortByNameDidTap() {
        allUsers = userModel.sortUsersByName()
    }

    func sortByRatingDidTap() {
        allUsers = userModel.sortUsersByRating()
    }

    func userProfileDidTap(withIndex indexPath: IndexPath) {
        let userInfo = allUsers[indexPath.row]
        onUserProfileDidTap?(userInfo)
    }
}
