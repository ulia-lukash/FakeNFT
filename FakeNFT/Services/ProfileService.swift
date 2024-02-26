//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 21.02.2024.
//

import Foundation

final class ProfileService: RequestService {

    // MARK: - Public Properties

    static let shared = ProfileService()
    static let didChangeProfileNotification = Notification.Name(rawValue: "Did fetch PROFILE")

    // MARK: - Private Properties

    private (set) var user: User?
    private (set) var profile: Profile?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let defaults = UserDefaults.standard

    // MARK: - Public Methods

    func fetchProfile() {

        if task != nil { return }

        guard let request = makeGetRequest(path: RequestConstants.profileFetchEndpoint) else {
            return assertionFailure("Failed to make PROFILE REQUEST")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<Profile, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                NotificationCenter.default.post(
                    name: ProfileService.didChangeProfileNotification,
                    object: self,
                    userInfo: ["profile": self.profile as Any] )
            case .failure(let error):
                assertionFailure("Failed to fetch PROFILE: " + error.localizedDescription)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    func changeLikesWith(_ likes: [UUID]) {
        let likes = likes.map {$0.uuidString.lowercased()}
        let likesString = likes.map { "likes=\($0)" }.joined(separator: "&")
        let reqData = Data(likesString.utf8)

        guard let request = makePutRequest(
            path: RequestConstants.profileFetchEndpoint,
            data: reqData) else { assertionFailure("Failed to make likes put request")
            return
        }
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let _ = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                } else {
                    print(NetworkError.httpStatusCode(statusCode))
                }
            } else if let error = error {
                print(NetworkError.urlRequestError(error))
            } else {
                print(NetworkError.urlSessionError)
            }
        }
        task.resume()
    }
}
