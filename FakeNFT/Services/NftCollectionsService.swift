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
    static let didChangeUserNotification = Notification.Name(rawValue: "Did fetch user")
    static let didChangeNftNotification = Notification.Name(rawValue: "Did fetch nft")
    static let didChangeNftsNotification = Notification.Name(rawValue: "Did fetch nfts")
    static let didChangeOrderNotification = Notification.Name(rawValue: "Did fetch order")
    static let didChangeProfileNotification = Notification.Name(rawValue: "Did fetch profile")

    // MARK: - Private Properties
    private (set) var collections: [NftCollection] = []
    private (set) var collection: NftCollection?
    private (set) var user: User?
    private (set) var nft: Nft?
    private (set) var nfts: [Nft] = []
    private (set) var order: Order?
    private (set) var profile: Profile?
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
                    name: NftCollectionsService.didChangeNotification,
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
                    name: NftCollectionsService.didChangeNotification,
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

    func fetchUser(withId id: String) {
        assert(Thread.isMainThread)
//        if task != nil { return }

        guard let request = makeGetRequest(path: RequestConstants.fetchUser(withId: id)) else {
            return assertionFailure("Failed to make a user request")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<UserResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.mapUser(user)
                NotificationCenter.default.post(
                    name: NftCollectionsService.didChangeUserNotification,
                    object: self,
                    userInfo: ["user": self.user as Any] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    func fetchNft(withId id: String) {
        assert(Thread.isMainThread)

        guard let request = makeGetRequest(path: RequestConstants.fetchNft(withId: id)) else {
            return assertionFailure("Failed to make an nft request")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<NftResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                self.mapNft(nft)
                NotificationCenter.default.post(
                    name: NftCollectionsService.didChangeNftsNotification,
                    object: self,
                    userInfo: ["nft": self.nft as Any] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    func fetchOrder() {

        assert(Thread.isMainThread)
        if task != nil { return }

        guard let request = makeGetRequest(path: RequestConstants.orderFetchEndpoint) else {
            return assertionFailure("Failed to make order request")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<Order, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = order
                NotificationCenter.default.post(
                    name: NftCollectionsService.didChangeOrderNotification,
                    object: self,
                    userInfo: ["order": self.order as Any] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    func fetchProfile() {

        assert(Thread.isMainThread)
//        if task != nil { return }

        guard let request = makeGetRequest(path: RequestConstants.profileFetchEndpoint) else {
            return assertionFailure("Failed to make profile request")}
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<Profile, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                NotificationCenter.default.post(
                    name: NftCollectionsService.didChangeProfileNotification,
                    object: self,
                    userInfo: ["profile": self.profile as Any] )
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    private func mapNft(_ nft: NftResponse) {
        guard let id = UUID(uuidString: nft.id) else { return }
        self.nfts.append(Nft(
            name: nft.name,
            id: id,
            images: nft.images,
            rating: nft.rating,
            description: nft.description,
            price: nft.price,
            author: nft.author))
    }

    private func mapNfts(_ nfts: [NftResponse]) {
        self.nfts = nfts.map { nft in
            return Nft(
                name: nft.name,
                id: UUID(uuidString: nft.id)!,
                images: nft.images,
                rating: nft.rating,
                description: nft.description,
                price: nft.price,
                author: nft.author)
        }
    }
    private func mapCollections(_ collections: [NftCollection]) {
        if let shouldFilterByName = defaults.object(forKey: "ShouldFilterByName") {
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

    private func mapUser(_ user: UserResponse) {
        guard let id = UUID(uuidString: user.id) else { return }
        self.user = User(
            name: user.name,
            website: user.website,
            id: id
        )
    }

    func putLikesData() {
        guard let request = makePutRequest(path: RequestConstants.profileFetchEndpoint) else { return }
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling PUT")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }

                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
    }

    func clearData() {
        self.nfts = []
    }
}

extension NftCollectionsService {

    private func makeGetRequest(path: String) -> URLRequest? {

        guard let baseURL = URL(string: RequestConstants.baseURL) else {
            assertionFailure("base url is nil")
            return nil
        }
        guard let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("failed to assemble request url")
            return nil
        }

        var request = URLRequest(url: url)

        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        return request
    }

    private func makePutRequest(path: String) -> URLRequest? {
        guard let baseURL = URL(string: RequestConstants.baseURL) else {
            assertionFailure("base url is nil")
            return nil
        }
        guard let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("failed to assemble request url")
            return nil
        }

        var request = URLRequest(url: url)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("66", forHTTPHeaderField: "likes")
        return request
    }
}
