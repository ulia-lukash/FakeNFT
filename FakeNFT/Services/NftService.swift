//
//  NftService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 21.02.2024.
//

import Foundation

final class NftService: RequestService {

    // MARK: - Public Properties

    static let shared = NftService()
    static let didChangeNftNotification = Notification.Name(rawValue: "Did fetch NFT")
    static let didChangeNftsNotification = Notification.Name(rawValue: "Did fetch NFTs")
    // MARK: - Private Properties

    private (set) var nft: Nft?
    private (set) var nfts: [Nft] = []
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let defaults = UserDefaults.standard

    // MARK: - Public Methods

    func fetchNft(withId id: String) {

        guard let request = makeGetRequest(path: RequestConstants.fetchNft(withId: id)) else {
            return assertionFailure("Failed to make an NFT request")}

        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<NftResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let nft):
                self.mapNft(nft)
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }

    func clearData() {
        self.nfts = []
    }

    // MARK: - Private Methods

    private func mapNft(_ nft: NftResponse) {
        guard let id = UUID(uuidString: nft.id) else { return }
        self.nft = Nft(
            name: nft.name,
            id: id,
            images: nft.images,
            rating: nft.rating,
            description: nft.description,
            price: nft.price,
            author: nft.author)
        
        NotificationCenter.default.post(
            name: NftService.didChangeNftNotification,
            object: self,
            userInfo: ["nft": self.nft as Any] )
    }
    
}
