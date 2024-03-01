import UIKit

protocol NFTModelProtocol: AnyObject {
    func getUserNFTCollection(nftIDs: [String]) -> [NFT]
    func saveNfts(nfts: [NFTData])
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

    private var nftsDB: [NFT] = []

    func getUserNFTCollection(nftIDs: [String]) -> [NFT] {
        nftsDB
    }

    func saveNfts(nfts: [NFTData]) {
        nftsDB = nfts.map {
            convert(nftData: $0)
        }
    }
}

extension NFTModel {
    func convert(nftData: NFTData) -> NFT {
        return NFT(
            id: nftData.id,
            image: nftData.images,
            name: String(nftData.name.split(separator: " ")[0]),
            isLiked: false,
            rating: nftData.rating,
            price: String(nftData.price))
    }
}
