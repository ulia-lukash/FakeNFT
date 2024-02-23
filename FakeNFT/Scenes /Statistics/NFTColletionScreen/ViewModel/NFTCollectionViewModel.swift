import Foundation

protocol NFTCollectionViewModelProtocol: AnyObject {
    var userNFTCollection: [NFT] { get }
}

final class NFTCollectionViewModel: NFTCollectionViewModelProtocol {
    private(set) var userNFTCollection: [NFT] = []

    private let NFTModel: NFTModelProtocol

    init(for model: NFTModelProtocol) {
        NFTModel = model
        userNFTCollection = NFTModel.getUserNFTCollection()
    }
}
