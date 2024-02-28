//
//  HelperMyNftProtocol.swift
//  FakeNFT
//
//  Created by Григорий Машук on 27.02.24.
//

import Foundation
protocol HelperMyNftProtocol {
    func createMyListNftCellModels(_ listMyNft: [MyListNFT]) -> [MyNFTCellModel]
    func networkFormat(likes: [String]) -> String
    func createLikesListNftCellModels(_ listMyNft: [MyListNFT]) -> [FavCollCellModel]
}

final class HelperMyNft {
    private func converMyNftUI(_ model: MyListNFT) -> MyNFTCellModel {
        MyNFTCellModel(urlNFT: URL(string: model.images.first ?? ""),
                       nameNFT: model.name,
                       nameAuthor: model.author,
                       rating: Double(model.rating),
                       priceETN: Float(model.price),
                       id: model.id,
                       islike: false)
    }
    
    private func createListMyNft(_ listMyNft: [MyListNFT]) -> [MyNFTCellModel] {
        listMyNft.map { converMyNftUI($0) }
    }
    
    private func converLikesNftUI(_ model: MyListNFT) -> FavCollCellModel {
        FavCollCellModel(urlNFT: URL(string: model.images.first ?? ""),
                         nameNFT: model.name,
                         rating: Double(model.rating),
                         priceETN: Float(model.price),
                         id: model.id)
    }
    
    private func createListLikesNft(_ listMyNft: [MyListNFT]) -> [FavCollCellModel] {
        listMyNft.map { converLikesNftUI($0) }
    }
    
    func networkFormatString(likes: [String]) -> String {
        let likesParams = likes.map { "likes=\($0)" }
        let likesQueryString = likesParams.joined(separator: "&")
        return likesQueryString
    }
}

extension HelperMyNft: HelperMyNftProtocol {
    func createMyListNftCellModels(_ listMyNft: [MyListNFT]) -> [MyNFTCellModel] {
        createListMyNft(listMyNft)
    }
    
    func createLikesListNftCellModels(_ listMyNft: [MyListNFT]) -> [FavCollCellModel] {
        createListLikesNft(listMyNft)
    }
    
    func networkFormat(likes: [String]) -> String {
        networkFormatString(likes: likes)
    }
}
