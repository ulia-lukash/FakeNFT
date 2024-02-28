import Foundation

typealias UsersCompletion = (Result<[UserData], Error>) -> Void

protocol UserService {
    func loadUsers(completion: @escaping UsersCompletion)
}

final class UserServiceImpl: UserService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUsers(completion: @escaping UsersCompletion) {
        let request = UsersRequest()
        networkClient.send(request: request, type: [UserData].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
