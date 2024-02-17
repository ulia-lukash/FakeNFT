//
//  NftCollectionCellViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 17.02.2024.
//

import Foundation

final class NftCollectionCellViewModel {

    private let service = NftCollectionsService.shared
    private var nftServiceObserver: NSObjectProtocol?
    var onChange: (() -> Void)?

    private(set) var nft: Nft? {
        didSet {
            onChange?()
        }
    }
    func fetchNft(withId id: String) {
        nftServiceObserver = NotificationCenter.default
            .addObserver(
                forName: NftCollectionsService.didChangeNftNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.nft = service.nft
                }
        DispatchQueue.global(qos: .utility).async {
            self.service.fetchCollection(withId: id)
        }
    }
}
