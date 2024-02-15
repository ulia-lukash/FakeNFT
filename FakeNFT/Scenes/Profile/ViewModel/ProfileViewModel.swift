//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Григорий Машук on 12.02.24.
//

import Foundation

protocol ProfileViewModelProtocol {
    func loadProfile(id: String)
    func makeErrorModel(error: Error) -> ErrorModel
    func makeProfileUIModel(networkModel: Profile) -> ProfileUIModel
    func makeTableCellModel(networkModel: Profile) -> TableCellModel
    func setCellModel(cellModel: TableCellModel)
    func createTextCell(text: String, count: String) -> String
    func setProfileUIModel(model: ProfileUIModel)
    func getProfileUIModel() -> ProfileUIModel?
    func setStateLoading()
}

enum ProfileState {
    case initial, loading, failed(Error), data(Profile)
}

final class ProfileViewModel {
    @Observable<TableCellModel>
    private(set) var cellModel: TableCellModel = TableCellModel(countNFT: "",
                                                                countFavoritesNFT: "")
    @Observable<ProfileState> private(set) var state: ProfileState = .initial
    
    private(set) var profileUIModel: ProfileUIModel?
    
    private let service: ProfileService
    
    init(service: ProfileService) {
        self.service = service
    }
}

extension ProfileViewModel: ProfileViewModelProtocol {
    func loadProfile(id: String) {
        service.loadProfile(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                state = .data(profile)
            case .failure(let error):
                state = .failed(error)
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
            self.state = .loading
        }
    }
    
    func makeProfileUIModel(networkModel: Profile) -> ProfileUIModel {
        let url = URL(string: networkModel.avatar)
        let name = networkModel.name
        let description = networkModel.description
        let link = networkModel.website
        return ProfileUIModel(url: url,
                              name: name,
                              description: description,
                              link: link)
    }
    
    func makeTableCellModel(networkModel: Profile) -> TableCellModel {
        TableCellModel(countNFT: "\(networkModel.nfts.count)",
                       countFavoritesNFT: "\(networkModel.likes.count)")
    }
    
    func createTextCell(text: String, count: String) -> String {
        text + "  " + "(\(count))"
    }
    
    func setProfileUIModel(model: ProfileUIModel) {
        self.profileUIModel = model
    }
    
    func setCellModel(cellModel: TableCellModel) {
        self.cellModel = cellModel
    }
    
    func setStateLoading() {
        self.state = .loading
    }
    
    func getProfileUIModel() -> ProfileUIModel? {
        self.profileUIModel
    }
}
