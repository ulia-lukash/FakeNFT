import Foundation

typealias ProfileCompletion = (Result<ProfileData, Error>) -> Void

protocol ProfileService {
    func loadProfile(id: String, completion: @escaping ProfileCompletion)
    func setLikes(nfts: [String], completion: @escaping ProfileCompletion)
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
        let request = LikesRequest(nfts: nfts)

        networkClient.send(request: request, type: ProfileData.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
