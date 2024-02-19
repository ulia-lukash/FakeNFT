//
//  MyNFTViewModel.swift
//  FakeNFT
//
//  Created by Григорий Машук on 19.02.24.
//

import Foundation
import Kingfisher

protocol MyNFTViewModelProtocol {
    func loadMyNFT()
    func loadNameAuthor()
}

enum MyNFTState {
    case initial, loading, update, failed(Error), data([MyNFTCellModel])
}

final class MyNFTViewModel {
    
}

private extension MyNFTViewModel {
    func convertUI(_ networkModel: MyNFT, nameAuthor: String) -> MyNFTCellModel {
        MyNFTCellModel(urlNFT: URL(string: networkModel.images.first ?? ""),
                       nameNFT: networkModel.name,
                       rating: Double(networkModel.rating),
                       priceETN: networkModel.price)
    }
    
//    func createListNFT(listNft: [MyNFT]) -> [MyNFTCellModel] {
//        listNft.map { convertUI($0, nameAuthor: <#String#>) }
//    }
}

extension MyNFTViewModel: MyNFTViewModelProtocol {
    func loadNameAuthor() {}
    func loadMyNFT() {}
    
}
