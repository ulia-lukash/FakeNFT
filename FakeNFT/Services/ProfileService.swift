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
}
