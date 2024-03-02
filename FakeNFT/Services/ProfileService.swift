import Foundation

typealias ProfileCompletion = (Result<ProfileData, Error>) -> Void
typealias OrderCompletion = (Result<OrderData, Error>) -> Void

protocol ProfileService {
    func loadProfile(id: String, completion: @escaping ProfileCompletion)
    func setLikes(nfts: [String], completion: @escaping ProfileCompletion)
    func loadOrder(completion: @escaping OrderCompletion)
    func setOrder(nfts: [String], completion: @escaping OrderCompletion)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(id: String, completion: @escaping ProfileCompletion) {
        let request = ProfileByIdRequest(id: id)
        networkClient.send(request: request, type: ProfileData.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setLikes(nfts: [String], completion: @escaping ProfileCompletion) {
        let request = PutLikesRequest(nfts: nfts)

        networkClient.send(request: request, type: ProfileData.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadOrder(completion: @escaping OrderCompletion) {
        let request = GetOrderRequest()

        networkClient.send(request: request, type: OrderData.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setOrder(nfts: [String], completion: @escaping OrderCompletion) {
        let request = PutOrderRequest(nfts: nfts)

        networkClient.send(request: request, type: OrderData.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
