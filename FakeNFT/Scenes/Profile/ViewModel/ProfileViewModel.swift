//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Григорий Машук on 12.02.24.
//

import Foundation

protocol ProfileViewModelProtocol {
    func loadProfile(id: String)
    func updateProfile(newModel: ProfileUIModel)
    func makeErrorModel(error: Error) -> ErrorModel
    func makeProfileUIModel(networkModel: Profile) -> ProfileUIModel
    func makeTableCellModel(networkModel: Profile) -> TableCellModel
    func setCellModel(cellModel: TableCellModel)
    func createTextCell(text: String, count: String) -> String
    func setProfileUIModel(model: ProfileUIModel)
    func setProfileID(id: String)
    func getProfileUIModel() -> ProfileUIModel?
    func getProfile() -> Profile?
    func setStateLoading()
    func stringClear(str: String) -> String
}

//MARK: - ProfileViewModel
final class ProfileViewModel {
    @Observable<TableCellModel>
    private(set) var cellModel: TableCellModel = TableCellModel(countNFT: "\(0)",
                                                                countFavoritesNFT: "\(0)")
    @Observable<ProfileState> private(set) var state: ProfileState = .initial
    
    private(set) var profileUIModel: ProfileUIModel?
    private(set) var profile: Profile?
    private(set) var profileID: String?
    private let service: ProfileService
    
    init(service: ProfileService) {
        self.service = service
    }
}

private extension ProfileViewModel {
    //MARK: - private func
    func createNetworkFormat(_ newModel: ProfileUIModel) -> String {
        var json: [String: String] = [:]
        guard let model = profileUIModel else { return "" }
        if newModel.description != model.description {
            json[JsonKey.description.rawValue] = newModel.description
        }
        if newModel.name != model.name {
            json[JsonKey.name.rawValue] = newModel.name
        }
        if newModel.link != model.link {
            json[JsonKey.website.rawValue] = newModel.link
        }
        if newModel.avatar != model.avatar {
            json[JsonKey.avatar.rawValue] = newModel.avatar?.absoluteString
        }
        let dto = String(json.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast())
        return dto
    }
    
    func saveProfile(model: Profile) {
        self.profile = model
    }
}

//MARK: - ProfileViewModelProtocol
extension ProfileViewModel: ProfileViewModelProtocol {
    func loadProfile(id: String) {
        service.loadProfile(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self.saveProfile(model: profile)
                    self.state = .data(profile)
                case .failure(let error):
                    self.state = .failed(error)
                }
            }
        }
    }
    
    func updateProfile(newModel: ProfileUIModel) {
        let json = createNetworkFormat(newModel)
        if !json.isEmpty {
            state = .update
            guard let profileID else { return }
            service.updateProfile(dto: json, id: profileID) { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async  {
                    switch result {
                    case .success(let profile):
                        self.saveProfile(model: profile)
                        self.state = .data(profile)
                    case .failure(let error):
                        self.state = .failed(error)
                    }
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
            self.state = .loading
        }
    }
    
    func makeProfileUIModel(networkModel: Profile) -> ProfileUIModel {
        let url = URL(string: networkModel.avatar)
        let name = networkModel.name
        let description = networkModel.description
        let link = networkModel.website
        return ProfileUIModel(avatar: url,
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
    
    func setProfileID(id: String) {
        profileID = id
    }
    
    func getProfileUIModel() -> ProfileUIModel? {
        self.profileUIModel
    }
    
    func getProfile() -> Profile? {
        self.profile
    }
    
    func stringClear(str: String) -> String {
        str.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
}
