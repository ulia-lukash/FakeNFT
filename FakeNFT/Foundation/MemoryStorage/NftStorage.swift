import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: NFTData)
    func getNft(with id: String) -> NFTData?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: NFTData] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: NFTData) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> NFTData? {
        syncQueue.sync {
            storage[id]
        }
    }
}
