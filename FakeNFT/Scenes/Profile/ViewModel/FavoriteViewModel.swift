//
//  FavoriteViewModel.swift
//  FakeNFT
//
//  Created by Григорий Машук on 26.02.24.
//

import Foundation

protocol FavoriteViewModelProtocol {
    func likes()
    func loadNftLikes()
    func setCurrentLikeId(id: String)
    func setLikesId(likesId: [String])
    func createCellModel(index: Int) -> FavCollCellModel
    func setLikeIndexPath(indexPath: IndexPath)
}

//MARK: - FavoriteViewModel
final class FavoriteViewModel {
    @Observable<MyNftState> private(set) var state: MyNftState = .initial
    private(set) var likesId: [String] = []
    private(set) var likesNft: [FavCollCellModel] = []
    private(set) var currentLikeId: String?
    private(set) var likeIndexPath: IndexPath?
    private let service: FavoriteNftServiceProtocol
    private let helperMyNft: HelperMyNftProtocol = HelperMyNft()
    
    init(service: FavoriteNftServiceProtocol) {
        self.service = service
    }
}

//MARK: - private extension
private extension FavoriteViewModel {
    func createLikesString(likes: [String], like: String) -> String {
        helperMyNft.networkFormat(likes: likes.filter { $0 != like })
    }
}

//MARK: - FavoriteViewModelProtocol
extension FavoriteViewModel: FavoriteViewModelProtocol {
    func loadNftLikes() {
        service.loadLikesNft(listId: likesId) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let likesNft):
                self.likesNft = helperMyNft.createLikesListNftCellModels(likesNft)
                state = .data
            case .failure(let error):
                state = .failed(error)
            }
        }
    }
    
    func likes() {
        guard let currentLikeId else { return }
        let likesString = createLikesString(likes: likesId, like: currentLikeId)
        service.likes(likes: likesString) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let likes):
                self.likesId = likes.likesId
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
    func setCurrentLikeId(id: String) {
        currentLikeId = id
    }
    
    func setLikesId(likesId: [String]) {
        self.likesId = likesId
    }
    
    func createCellModel(index: Int) -> FavCollCellModel {
        likesNft[index]
    }
    
    func setLikeIndexPath(indexPath: IndexPath) {
        likeIndexPath = indexPath
    }
}
