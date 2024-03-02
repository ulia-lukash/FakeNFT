import UIKit

protocol NFTModelProtocol: AnyObject {
    func getUserNFTCollection() -> [NFT]
    func saveNfts(nfts: [NFTData])
    func saveLikesInfo(nftIds: [String])
    func removeFromLiked(nftIds: [String])
    func setLikesInfo(nftIds: [String])
    var likedNfts: [String] { get }
}

final class NFTModel: NFTModelProtocol {
    // swiftlint:disable force_unwrapping
/*
    private var mockNFTs: [NFT] = [
        NFT(id: "some id", image: UIImage(named: "Grace")!, name: "Grace", isLiked: false, rating: 2, price: "1,78")
//        NFT(image: UIImage(named: "Zoe")!, name: "Zoe", isLiked: false, rating: 2, price: "1,78"),
//        NFT(image: UIImage(named: "Stella")!, name: "Stella", isLiked: false, rating: 2, price: "1,78"),
//        NFT(image: UIImage(named: "Toast")!, name: "Toast", isLiked: false, rating: 2, price: "1,78"),
//        NFT(image: UIImage(named: "Zeus")!, name: "Zeus", isLiked: false, rating: 2, price: "1,78")
    ]
*/
    // swiftlint:enable force_unwrapping

    private var nftsDB: [String: NFT] = [:]
    private(set) var likedNfts: [String] = []

    func getUserNFTCollection() -> [NFT] {
        updateNftDB()
        let nfts = Array(nftsDB.values).sorted {
            $0.name > $1.name
        }
        return nfts
    }

    func saveNfts(nfts: [NFTData]) {
        nfts.forEach {
            nftsDB[$0.id] = convert(nftData: $0)
        }
        updateNftDB()
    }

    func setLikesInfo(nftIds: [String]) {
        likedNfts.removeAll()
        likedNfts = nftIds
        updateNftDB()
    }

    func saveLikesInfo(nftIds: [String]) {
        likedNfts.append(contentsOf: nftIds)
        updateNftDB()
    }

    func removeFromLiked(nftIds: [String]) {
        likedNfts.removeAll {
            nftIds.contains($0)
        }
        updateNftDB()
    }

    func updateNftDB() {
        let db: [String: NFT] = nftsDB
        db.forEach { id, _ in
            nftsDB[id]?.isLiked = likedNfts.contains(id)
        }
    }
}

extension NFTModel {
    func convert(nftData: NFTData) -> NFT {
        return NFT(
            id: nftData.id,
            image: nftData.images,
            name: String(nftData.name.split(separator: " ")[0]),
            isLiked: likedNfts.contains(nftData.id),
            rating: nftData.rating,
            price: String(nftData.price))
    }
}
