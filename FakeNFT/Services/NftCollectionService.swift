//
//  NftCollectionsService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 12.02.2024.
//

import Foundation

final class NftCollectionService: RequestService {

    // MARK: - Public Properties

    static let shared = NftCollectionService()
    static let didChangeNotification = Notification.Name(rawValue: "NftCollectionsServiceDidChange")

    // MARK: - Private Properties

    private (set) var collections: [NftCollection] = []
    private (set) var collection: NftCollection?

    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let defaults = UserDefaults.standard

    // MARK: - Public Methods
    func fetchCollections() {

        assert(Thread.isMainThread)
        if task != nil { return }

        guard let request = makeGetRequest(path: RequestConstants.collectionsFetchEndpoint) else {
            return assertionFailure("Failed to make collections request")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[NftCollection], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let collections):
                self.mapCollections(collections)
                NotificationCenter.default.post(
                    name: NftCollectionService.didChangeNotification,
                    object: self,
                    userInfo: ["collections": self.collections] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    func fetchCollection(withId id: String) {
        if task != nil { return }

        guard let request = makeGetRequest(path: RequestConstants.fetchCollection(withId: id)) else {
            return assertionFailure("Failed to make a collection request")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<NftCollection, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let collection):
                self.mapCollection(collection)
                NotificationCenter.default.post(
                    name: NftCollectionService.didChangeNotification,
                    object: self,
                    userInfo: ["collection": self.collection as Any] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    private func mapCollections(_ collections: [NftCollection]) {
        if defaults.object(forKey: "ShouldFilterByName") != nil {
            self.collections = collections.sorted(by: {$0.name < $1.name})
        } else {
            self.collections = collections.sorted(by: {$0.nfts.count > $1.nfts.count})
        }
    }

    private func mapCollection(_ collection: NftCollection) {
        self.collection = NftCollection(
            name: collection.name,
            cover: collection.cover,
            nfts: collection.nfts,
            description: collection.description,
            author: collection.author,
            id: collection.id)
    }
}
