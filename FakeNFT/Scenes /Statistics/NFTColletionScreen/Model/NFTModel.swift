import UIKit

protocol NFTModelProtocol: AnyObject {
    func getUserNFTCollection() -> [NFT]
}

final class NFTModel: NFTModelProtocol {
    // swiftlint:disable force_unwrapping
    private var mockNFTs: [NFT] = [
        NFT(icon: UIImage(named: "Grace")!, name: "Grace", isLiked: false, rating: 2, price: "1,78"),
        NFT(icon: UIImage(named: "Zoe")!, name: "Zoe", isLiked: false, rating: 2, price: "1,78"),
        NFT(icon: UIImage(named: "Stella")!, name: "Stella", isLiked: false, rating: 2, price: "1,78"),
        NFT(icon: UIImage(named: "Toast")!, name: "Toast", isLiked: false, rating: 2, price: "1,78"),
        NFT(icon: UIImage(named: "Zeus")!, name: "Zeus", isLiked: false, rating: 2, price: "1,78")
    ]
    // swiftlint:enable force_unwrapping

    func getUserNFTCollection() -> [NFT] {
        mockNFTs
    }
}
