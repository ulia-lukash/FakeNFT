import UIKit

protocol NFTModelProtocol: AnyObject {
    func getUserNFTCollection() -> [NFT]
    func saveNfts(nfts: [NFTData])
    func saveLikesInfo(nftIds: [String])
    func removeFromLiked(nftIds: [String])
    func setLikesInfo(nftIds: [String])
    func setCurrentOrder(nfts: [String])
    func saveCurrentOrderInfo(nfts: [String])
    func removeFromOrder(nft: [String])
    var likedNfts: [String] { get }
    var orderedNfts: [String] { get }
}

final class NFTModel: NFTModelProtocol {
    private var nftsDB: [String: NFT] = [:]

    private(set) var likedNfts: [String] = []

    private(set) var orderedNfts: [String] = []

    func getUserNFTCollection() -> [NFT] {
        updateLikesInNftDB()
        let nfts = Array(nftsDB.values).sorted {
            $0.name > $1.name
        }
        return nfts
    }

    func setCurrentOrder(nfts: [String]) {
        orderedNfts = nfts
        updateOrdersInNftDB()
    }

    func saveCurrentOrderInfo(nfts: [String]) {
        orderedNfts.append(contentsOf: nfts)
        updateOrdersInNftDB()
    }

    func removeFromOrder(nft: [String]) {
        orderedNfts.removeAll {
            nft.contains($0)
        }
        updateOrdersInNftDB()
    }

    func saveNfts(nfts: [NFTData]) {
        nfts.forEach {
            nftsDB[$0.id] = convert(nftData: $0)
        }
        updateLikesInNftDB()
    }

    func setLikesInfo(nftIds: [String]) {
        likedNfts.removeAll()
        likedNfts = nftIds
        updateLikesInNftDB()
    }

    func saveLikesInfo(nftIds: [String]) {
        likedNfts.append(contentsOf: nftIds)
        updateLikesInNftDB()
    }

    func removeFromLiked(nftIds: [String]) {
        likedNfts.removeAll {
            nftIds.contains($0)
        }
        updateLikesInNftDB()
    }

    func updateLikesInNftDB() {
        let db: [String: NFT] = nftsDB
        db.forEach { id, _ in
            nftsDB[id]?.isLiked = likedNfts.contains(id)
        }
    }

    func updateOrdersInNftDB() {
        let db: [String: NFT] = nftsDB
        db.forEach { id, _ in
            nftsDB[id]?.isOrdered = orderedNfts.contains(id)
        }
    }
}

extension NFTModel {
    func convert(nftData: NFTData) -> NFT {
        return NFT(
            id: nftData.id,
            image: nftData.images,
            name: String(nftData.name.split(separator: " ")[0]),
            rating: nftData.rating,
            price: String(nftData.price),
            isLiked: likedNfts.contains(nftData.id),
            isOrdered: orderedNfts.contains(nftData.id)
        )
    }
}
