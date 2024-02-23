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
    func loadSortForPrice()
    func loadSortForRating()
    func loadSortForName()
    func makeErrorModel(error: Error) -> ErrorModel
    func getListMyNft() -> [MyNFTCellModel]
    func getCurrentListMyNft() -> [MyNFTCellModel]
    func getIndexPaths() -> [IndexPath]
    func sort()
    func reset()
    func getSortState() -> SortState
    func setSortState(state: SortState)
}

final class MyNftViewModel {
    @Observable<MyNftState> private(set) var state: MyNftState = .initial
    @Observable<SortState> private(set) var sortState: SortState = .none
    
    private var indexPaths: [IndexPath] = []
    private var listMyNft: [MyNFTCellModel] = []
    private var currentPageData: [MyNFTCellModel] = []
    private let service: MyNFTServiceProtocol
    private let mainQueue = DispatchQueue.main
    private var isNoneSort = false
    private var currentPage = 0
    private(set) var flagDownload = true
    
    init(service: MyNFTServiceProtocol) {
        self.service = service
    }
}

private extension MyNftViewModel {
    func convertUI(_ model: MyListNFT) -> MyNFTCellModel {
        MyNFTCellModel(urlNFT: URL(string: model.images.first ?? ""),
                       nameNFT: model.name,
                       nameAuthor: "Grifon",
                       rating: Double(model.rating),
                       priceETN: Float(model.price))
    }
    
    func createListMyNft(_ listMyNft: [MyListNFT]) -> [MyNFTCellModel] {
        listMyNft.map { convertUI($0) }
    }
    
    func setListMyNft(_ listMyNft: [MyNFTCellModel]) {
        self.listMyNft = listMyNft
    }
    
    func addNftInList(_ nft: [MyNFTCellModel]) {
        listMyNft.append(contentsOf: nft)
    }
    
    func sortPage(nft: [MyNFTCellModel]) {
        self.listMyNft.append(contentsOf: nft)
        let startIndex = currentPage == 0 ? 0 : ApiConstants.pageSize * currentPage
        currentPage += 1
        let endIndex = min(startIndex + ApiConstants.pageSize, listMyNft.count)
        if flagDownload {
            indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
            currentPageData = Array(listMyNft[startIndex..<endIndex])
        }
    }
    
    func resetMyListNft() {
        listMyNft = []
    }
    
    func resetIsNoneSort() {
        isNoneSort = false
    }
    
    func resetCurrentPage() {
        currentPage = 0
    }
    
    func resetPage() {
        service.resetPage()
    }
    
    func resetCurrentListMyNft() {
        currentPageData = []
    }
    
    func resetIndexPath() {
        indexPaths = []
    }
    
    func setIsDownload() {
        flagDownload = true
    }
    
    func loadForSortState() {
        switch sortState {
        case .price:
            loadSortForPrice()
        case .rating:
            loadSortForRating()
        case .name:
            loadSortForName()
        case .none:
            loadMyNFT()
        }
    }
    
    func result(_ result: Result<[MyListNFT], Error>) {
        isNoneSort = true
        if flagDownload {
            self.mainQueue.async {
                switch result {
                case .success(let myNft):
                    let nft = self.createListMyNft(myNft)
                    if !nft.isEmpty {
                        self.sortPage(nft: nft)
                        self.state = .data(nft)
                    } else {
                        self.flagDownload = false
                    }
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }
}

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
            loadMyNFT()
        }
    }
    
    func loadMyNFT() {
        state = .loading
        service.loadMyNFT { [weak self] result in
            guard let self else { return }
            self.result(result)
        }
    }
    
    func loadSortForPrice() {
        state = .loading
        service.filterForPrice { [weak self] result in
            guard let self else { return }
            self.result(result)
        }
    }
    
    func loadSortForRating() {
        state = .loading
        service.filterForRating { [weak self] result in
            guard let self else { return }
            self.result(result)
        }
    }
    
    func loadSortForName() {
        self.state = .loading
        service.filterForName { [weak self] result in
            guard let self else { return }
            self.result(result)
        }
    }
    
    func getListMyNft() -> [MyNFTCellModel] {
        listMyNft
    }
    
    func getCurrentListMyNft() -> [MyNFTCellModel] {
        currentPageData
    }
    
    func getSortState() -> SortState {
        sortState
    }
    
    func getIndexPaths() -> [IndexPath] {
        indexPaths
    }
    
    func sort() {
        loadForSortState()
    }
    
    func setSortState(state: SortState) {
        self.sortState = state
    }

    func reset() {
        resetIndexPath()
        resetPage()
        resetMyListNft()
        resetCurrentListMyNft()
        resetCurrentPage()
        resetIsNoneSort()
        setIsDownload()
    }
}
