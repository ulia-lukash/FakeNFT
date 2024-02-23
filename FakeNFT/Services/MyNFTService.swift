//
//  MyNFTService.swift
//  FakeNFT
//
//  Created by Григорий Машук on 20.02.24.
//

import Foundation

typealias MyNftCompletion = (Result<[MyListNFT], Error>) -> Void

protocol MyNFTServiceProtocol {
    func loadMyNFT(completion: @escaping MyNftCompletion)
    func filterForPrice(completion: @escaping MyNftCompletion)
    func filterForRating(completion: @escaping MyNftCompletion)
    func filterForName(completion: @escaping MyNftCompletion)
    func resetPage()
}

final class MyNFTServiceIml: MyNFTServiceProtocol {
    private let networkClient: NetworkClient
    private let storage: MyNftStorageProtocol
    private let queue = DispatchQueue(label: "get-myNft", qos: .userInitiated)
    
    init(networkClient: NetworkClient, storage: MyNftStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    private (set) var lastLoadedPage: Int = 0
}

private extension MyNFTServiceIml {
    func setPage() {
        lastLoadedPage = lastLoadedPage == 0 ? 1 : lastLoadedPage + 1
    }
    
    func load(request: NetworkRequest,
              completion: @escaping MyNftCompletion) {
        networkClient.send(request: request,
                           type: [MyListNFT].self,
                           completionQueue: queue) { result in
            switch result {
            case .success(let myNft):
                completion(.success(myNft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension MyNFTServiceIml {
    func loadMyNFT(completion: @escaping MyNftCompletion) {
        setPage()
        let request = MyNftRequest(page: lastLoadedPage)
        load(request: request, completion: completion)
    }
    
    func filterForPrice(completion: @escaping MyNftCompletion) {
        setPage()
        let request = MyNftSortRequest(sort: .price, page: lastLoadedPage)
        load(request: request, completion: completion)
    }
    
    func filterForRating(completion: @escaping MyNftCompletion) {
        setPage()
        let request = MyNftSortRequest(sort: .rating, page: lastLoadedPage)
        load(request: request, completion: completion)
    }
    
    func filterForName(completion: @escaping MyNftCompletion) {
        setPage()
        let request = MyNftSortRequest(sort: .name, page: lastLoadedPage)
        load(request: request, completion: completion)
    }
    
    func resetPage() {
        lastLoadedPage = 0
    }
    
//    func fetchPhotosNextPage() {
//        assert(Thread.isMainThread)
//        guard photosNextPageTask == nil else { return }
//        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
//        lastLoadedPage = nextPage
//        var request: URLRequest?
//        do { let modelRequest = try imageListServiceRequestForPage(page: nextPage)
//            request = modelRequest
//        }
//        catch {
//            let errorRequest = NetworkError.urlComponentsError
//            print(errorRequest)
//        }
//        guard let request = request else { return }
//        let task = urlSession.objectTask(for: request) { [weak self] (result: Result <[PhotoResult], Error>) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let listModel):
//                listModel.forEach {
//                    let photoModel = self.convertModel(model: $0)
//                        self.photos.append(photoModel)
//                }
//                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: [Constants.userInfoKey: self.photos])
//                self.photosNextPageTask = nil
//            case .failure(let error):
//                print(error)
//            }
//        }
//        self.photosNextPageTask = task
//        task.resume()
//    }
//
//    func imageListServiceRequestForPage(page: Int) throws -> URLRequest {
//        guard var component = component else { throw NetworkError.urlComponentsError}
//        component.queryItems = [URLQueryItem(name: Constants.pageString, value: "\(page)")]
//        component.path = Constants.path
//        guard let url = component.url else { throw NetworkError.urlComponentsError}
//
//        guard let token = OAuth2TokenKeychainStorage().getToken() else { throw KeychainError.errorStorageToken}
//        let bearerToken = "\(ConstantsImageFeed.bearer) \(token)"
//
//        return URLRequest.makeHTTPRequestForModel(url: url, bearerToken: bearerToken, forHTTPHeaderField: ConstantsImageFeed.hTTPHeaderField)
//    }
    
//    func loadNftData() {
//             onLoad?(true)
//             var arrayWithNft: [Nft] = []
//             let dispatch = DispatchGroup()
//             service.loadByOrders { result in
//                 switch result {
//                 case .success(let order):
//                     for id in order {
//                         dispatch.enter()
//                         self.service.loadByNft(by: id) { models in
//                             switch models {
//                             case .success(let model):
//                                 arrayWithNft.append(model)
//                             case .failure(let error):
//                                 print(error.localizedDescription)
//                             }
//                             dispatch.leave()
//                         }
//                     }
//                 case .failure(let error):
//                     print(error.localizedDescription)
//                 }
//                 dispatch.notify(queue: .main) {
//                     let filterNfts = self.sortingArrayFromServer(arrayWithNft)
//                     self.nft = filterNfts
//                     self.onLoad?(false)
//                 }
//             }
//         }
}

