//
//  MyNftViewModel.swift
//  FakeNFT
//
//  Created by Григорий Машук on 19.02.24.
//

import Foundation
import Kingfisher

protocol MyNftViewModelProtocol {
    func loadMyNFT()
    func makeErrorModel(error: Error) -> ErrorModel
    func getListMyNft() -> [MyNFTCellModel]
    func setSortState(state: SortState)
    func setLikeIndexPathAndUpdateId(_ indexPath: IndexPath?)
    func setUpdateId(index: Int)
    func saveProfile(profile: Profile?)
    func setState(state: MyNftState)
    var isUpdate: Bool { get set }
}

//MARK: - MyNftViewModel
final class MyNftViewModel {
    @Observable<MyNftState> private(set) var state: MyNftState = .initial
    @Observable<SortState> private(set) var sortState: SortState = .none
    
    private(set) var listMyNft: [MyNFTCellModel] = []
    private(set) var profile: Profile?
    private(set) var likeId: String?
    private(set) var likeIndexPath: IndexPath?
    var isUpdate = false
    private let service: MyNFTServiceProtocol
    private let helperMyNft: HelperMyNftProtocol = HelperMyNft()
    
    init(service: MyNFTServiceProtocol) {
        self.service = service
    }
}

private extension MyNftViewModel {
    //MARK: - private func
    func convertUI(_ model: MyListNFT) -> MyNFTCellModel {
        MyNFTCellModel(urlNFT: URL(string: model.images.first ?? ""),
                       nameNFT: model.name,
                       nameAuthor: model.author,
                       rating: Double(model.rating),
                       priceETN: Float(model.price),
                       id: model.id,
                       islike: false)
    }
    
    func createListMyNft(_ listMyNft: [MyListNFT]) -> [MyNFTCellModel] {
        listMyNft.map { convertUI($0) }
    }
    
    func setIsDownload() {
        isUpdate = true
    }
    
    func createDataString(likes: [String], like: String, flag: Bool) -> String {
        var returnLikes: [String] = likes
        if flag {
            returnLikes.append(like)
        } else {
            returnLikes = returnLikes.filter { $0 != like }
        }
        
        return helperMyNft.networkFormat(likes: returnLikes)
    }
    
    func networkFormat(likes: [String]) -> String {
        let likesParams = likes.map { "likes=\($0)" }
        return likesParams.joined(separator: "&")
    }
    
    func sortListNft() -> [MyNFTCellModel] {
        var sortList: [MyNFTCellModel] = []
        switch sortState {
        case .price:
            sortList = listMyNft.sorted { $0.priceETN < $1.priceETN}
        case .rating:
            sortList = listMyNft.sorted { $0.rating < $1.rating }
        case .name:
            sortList = listMyNft.sorted { $0.nameNFT < $1.nameNFT }
        case .none:
            break
        }
        return sortList
    }
    
    func createMyListNftLikes() -> [MyNFTCellModel] {
        listMyNft.map { nft in
            MyNFTCellModel(urlNFT: nft.urlNFT,
                           nameNFT: nft.nameNFT,
                           nameAuthor: nft.nameAuthor,
                           rating: nft.rating,
                           priceETN: nft.priceETN,
                           id: nft.id,
                           islike: nft.id == likeId)
        }
    }
    
    func loadResult(_ result: Result<[MyListNFT], Error>) {
        var returnSortList: [MyNFTCellModel] = []
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch result {
            case .success(let myNft):
                let nft = helperMyNft.createMyListNftCellModels(myNft)
                returnSortList = nft
                if sortState != .none {
                    returnSortList = sortListNft()
                }
                listMyNft = returnSortList
                self.state = .data
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
    func updateResult(_ result: Result<Void, Error>) {
        self.state = .loading
        switch result {
        case .success():
            listMyNft = createMyListNftLikes()
            self.isUpdate = true
            self.state = .data
        case .failure(let error):
            self.state = .failed(error)
        }
    }
    
    func loadProfile(id: String, completion: @escaping ProfileCompletion) {
        service.loadProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//MARK: - MyNftViewModelProtocol
extension MyNftViewModel: MyNftViewModelProtocol {
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
            if !isUpdate { loadMyNFT() }
        }
    }
    
    func updateNft(flag: Bool) {
        state = .update
        guard let likeId,
              let likes = profile?.likes
        else { return }
        let dto = createDataString(likes: likes, like: likeId, flag: flag)
        service.updateNftPut(dto: dto) { [weak self] updateResult in
            guard let self else { return }
            service.loadProfile { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let profile):
                    self.profile = profile
                    self.updateResult(updateResult)
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }
    
    func loadMyNFT() {
        state = .loading
        guard let profile else { return }
        service.load(listId: profile.nfts){ [weak self] result in
            guard let self else { return }
            self.loadResult(result)
        }
    }
    
    func getListMyNft() -> [MyNFTCellModel] {
        listMyNft
    }
    
    func setLikeIndexPathAndUpdateId(_ indexPath: IndexPath?) {
        guard let indexPath else { return }
        likeIndexPath = indexPath
        likeId = listMyNft[indexPath.row].id
    }
    
    func setSortState(state: SortState) {
        self.sortState = state
    }
    
    func setUpdateId(index: Int) {
        likeId = listMyNft[index].id
    }
    
    func setState(state: MyNftState) {
        self.state = state
    }
    
    func saveProfile(profile: Profile?) {
        self.profile = profile
    }
    
    func nftIsLike(index: Int) -> Bool {
        guard let profile else { return false }
        return Set(profile.likes).contains(listMyNft[index].id)
    }
}
