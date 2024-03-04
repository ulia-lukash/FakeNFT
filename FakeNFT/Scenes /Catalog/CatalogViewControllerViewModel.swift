//
//  CatalogViewControllerViewModel.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 12.02.2024.
//

protocol CatalogViewModelProtocol: AnyObject {
    var collections: [NftCollection]? { get }
    func loadCollections()
    func setStateLoading()
    func collectionsNumber() -> Int
    func collectionsFilterByName()
    func collectionsFilterByNumber()
}

protocol CatalogViewModelDelegateProtocol: AnyObject {
    func showError()
}

final class CatalogViewModel: CatalogViewModelProtocol {

    @Observable<CatalogueState> private(set) var state: CatalogueState = .initial
    private let service: CollectionService
    private let defaults = UserDefaults.standard
    private(set) var collections: [NftCollection]?

    init(service: CollectionService) {
        self.service = service
    }

    func collectionsNumber() -> Int {
        collections?.count ?? 0
    }

    func collectionsFilterByName() {
        defaults.set(true, forKey: "ShouldFilterByName")
        collections?.sort(by: {$0.name < $1.name})
    }

    func collectionsFilterByNumber() {
        defaults.removeObject(forKey: "ShouldFilterByName")
        collections?.sort(by: {$0.nfts.count > $1.nfts.count})
    }

    func setStateLoading() {
        self.state = .loading
    }

    func loadCollections() {
        service.loadCollections { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let collections):
                    self.saveCollections(collections: collections)
                    self.state = .data(collections)
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
            self.state = .loading
        }
    }

    private func saveCollections(collections: [NftCollection]) {
        if defaults.object(forKey: "ShouldFilterByName") != nil {
            self.collections = collections.sorted(by: {$0.name < $1.name})
        } else {
            self.collections = collections.sorted(by: {$0.nfts.count > $1.nfts.count})
        }
    }
}
