import Foundation

protocol RatingViewModelProtocol: AnyObject {
    var onSortButtonTap: (() -> Void)? { get set }
    var onUsersListChange: (() -> Void)? { get set }
    var onUserProfileDidTap: ((User) -> Void)? { get set }

    var onLoadingState: (() -> Void)? { get set }
    var onDataState: (() -> Void)? { get set }
    var onErrorState: ((ErrorModel) -> Void)? { get set }

    var allUsers: [User] { get }
    func sortButtonDidTap()
    func sortByNameDidTap()
    func sortByRatingDidTap()
    func userProfileDidTap(withIndex indexPath: IndexPath)
    func viewDidLoad()
}

enum RatingViewModelDetailState {
    case initial, loading, failed(Error), data([UserData])
}

final class RatingViewModel: RatingViewModelProtocol {
    var onSortButtonTap: (() -> Void)?
    var onUsersListChange: (() -> Void)?
    var onUserProfileDidTap: ((User) -> Void)?
    var onLoadingState: (() -> Void)?
    var onDataState: (() -> Void)?
    var onErrorState: ((ErrorModel) -> Void)?

    var servicesAssembly: ServicesAssembly

    private(set) var allUsers: [User] = [] {
        didSet {
            onUsersListChange?()
        }
    }

    private var state = RatingViewModelDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }

    private let userModel: RatingModel

    init(for model: RatingModel, servicesAssembly: ServicesAssembly) {
        userModel = model
        self.servicesAssembly = servicesAssembly
    }

    func viewDidLoad() {
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            onLoadingState?()
            loadUsers()
        case .data(let usersData):
            onDataState?()
            userModel.saveUsers(users: usersData)
            allUsers = userModel.getUsers()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            onErrorState?(errorModel)
        }
    }

    private func loadUsers() {
        let users = userModel.getUsers()
        if !users.isEmpty {
            allUsers = users
            return
        }

        servicesAssembly.userService.loadUsers { [weak self] result in
            switch result {
            case .success(let usersData):
                self?.state = .data(usersData)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
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

extension RatingViewModel {
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
