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
    func makeErrorModel(error: Error) -> ErrorModel
    func setCurrentLikeId(index: Int)
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
    
    func isRemoveLikeId(_ listLikesId: [String]) -> Bool {
        if listLikesId.count < likesId.count, let currentLikeId {
            if let removeIndex = likesNft.firstIndex(where: { $0.id == currentLikeId }) {
                likesNft.remove(at: removeIndex)
                return true
            }
        }
        return false
    }
}

//MARK: - FavoriteViewModelProtocol
extension FavoriteViewModel: FavoriteViewModelProtocol {
    func loadNftLikes() {
        state = .loading
        service.loadLikesNft(listId: likesId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let likesNft):
                    self.likesNft = self.helperMyNft.createLikesListNftCellModels(likesNft)
                    self.state = .data
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }
    
    func likes() {
        guard let currentLikeId else { return }
        state = .loading
        let likesString = createLikesString(likes: likesId, like: currentLikeId)
        service.likes(likes: likesString) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let likes):
                    //Комментарий дляя ревью:
                   // при последнем тесте перестал удаляться последний id с сервера
                    self.state = self.isRemoveLikeId(
                        likes.likes) ?
                        .data :
                        .failed(FovoriteError.removeNft)
                    self.likesId = likes.likes
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }
    
    func makeErrorModel(error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = ConstLocalizable.errorNetwork
        default:
            message = ConstLocalizable.errorUnknown
        }
        let actionText = ConstLocalizable.errorRepeat
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            guard let self else { return }
            self.currentLikeId == nil ? loadNftLikes() : likes()
        }
    }
    
    func setCurrentLikeId(index: Int) {
        currentLikeId = likesNft[index].id
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
