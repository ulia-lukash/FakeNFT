import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: Nft)
    func getNft(with id: String) -> Nft?
    func getNfts() -> [Nft]?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: Nft] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: Nft) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> Nft? {
        syncQueue.sync {
            storage[id]
        }
    }

    func getNfts() -> [Nft]? {
        var nfts: [Nft] = []
        for nft in storage.values {
            syncQueue.sync {
                nfts.append(nft)
            }
        }
        return !nfts.isEmpty ? nfts : nil
    }
}
