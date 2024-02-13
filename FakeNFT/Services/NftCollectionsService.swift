//
//  NftCollectionsService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 12.02.2024.
//

import Foundation

final class NftCollectionsService {

    // MARK: - Public Properties

    static let shared = NftCollectionsService()
    static let didChangeNotification = Notification.Name(rawValue: "NftCollectionsServiceDidChange")

    // MARK: - Private Properties
    private (set) var collections: [NftCollection] = []
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let defaults = UserDefaults.standard

    // MARK: - Public Methods
    func fetchCollections() {

        assert(Thread.isMainThread)
        if task != nil { return }

        guard let request = makeRequest(path: RequestConstants.collectionsFetchEndpoint) else {
            return assertionFailure("Failed to make collections request")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[NftCollectionResponse], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let collections):
                self.mapCollections(collections)
                NotificationCenter.default.post(name: NftCollectionsService.didChangeNotification, object: self, userInfo: ["collections": self.collections] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    private func mapCollections(_ collections: [NftCollectionResponse]) {
        let cols = collections.map { item in
            return NftCollection(createdAt: item.createdAt, name: item.name, cover: item.cover, nfts: item.nfts, description: item.description, author: item.author, id: item.id)
        }
        if let shouldFilterByName = defaults.object(forKey: "ShouldFilterByName") {
            self.collections = cols.sorted(by: {$0.name < $1.name})
        } else {
            self.collections = cols.sorted(by: {$0.nfts.count > $1.nfts.count})
        }

    }

}

extension NftCollectionsService {

    private func makeRequest(path: String) -> URLRequest? {

        guard let baseURL = URL(string: RequestConstants.baseURL) else {
            assertionFailure("base url is nil")
            return nil
        }
        guard let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("failed to assemble request url")
            return nil
        }

        var request = URLRequest(url: url)

        request.setValue("\(RequestConstants.token)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return request
    }
}
