//
//  NftCollectionsService.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 12.02.2024.
//

typealias CollectionCompletion = (Result<NftCollection, Error>) -> Void
typealias CollectionsCompletion = (Result<[NftCollection], Error>) -> Void

protocol CollectionService {
    func loadCollection(id: String, completion: @escaping CollectionCompletion)
    func loadCollections(completion: @escaping CollectionsCompletion)
}

// MARK: - ProfileServiceImpl
final class CollectionServiceImpl {
    private let networkClient: NetworkClient
    private let storage: CollectionStorageProtocol

    init(networkClient: NetworkClient, storage: CollectionStorageProtocol) {
        self.storage = storage
        self.networkClient = networkClient
    }
}

// MARK: - ProfileService
extension CollectionServiceImpl: CollectionService {
    func loadCollections(completion: @escaping CollectionsCompletion) {
        if let collections = storage.getCollections() {
            completion(.success(collections))
            return
        }
        let request = GetCollectionsRequest()
        networkClient.send(request: request, type: [NftCollection].self) { [weak storage] result in
            switch result {
            case .success(let collections):
                storage?.saveCollections(collections: collections)
                completion(.success(collections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadCollection(id: String, completion: @escaping CollectionCompletion) {
        if let collection = storage.getCollection(with: id) {
            completion(.success(collection))
            return
        }
        let request = GetCollectionRequest(id: id)
        networkClient.send(request: request,
                           type: NftCollection.self) { [weak storage] result in
            switch result {
            case .success(let collection):
                storage?.saveCollection(collection: collection)
                completion(.success(collection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
