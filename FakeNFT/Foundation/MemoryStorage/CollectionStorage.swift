//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Uliana Lukash on 04.03.2024.
//

import Foundation

protocol CollectionStorageProtocol: AnyObject {
    func saveCollection(collection: NftCollection)
    func saveCollections(collections: [NftCollection])
    func getCollection(with id: String) -> NftCollection?
    func getCollections() -> [NftCollection]?
}

final class CollectionStorageImpl {
    private var storage: [String: NftCollection]?
    private let syncQueue = DispatchQueue(label: "sync-collection-queue")
}

extension CollectionStorageImpl: CollectionStorageProtocol {
    func saveCollection(collection: NftCollection) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            self.storage?[collection.id] = collection
        }
    }

    func saveCollections(collections: [NftCollection]) {
        syncQueue.async { [weak self] in
            guard let self else { return }
            for collection in collections {
                self.storage?[collection.id] = collection
            }
        }
    }

    func getCollection(with id: String) -> NftCollection? {
        syncQueue.sync { [weak self] in
            guard let self else { return nil }
            return self.storage?[id]
        }
    }

    func getCollections() -> [NftCollection]? {
        syncQueue.sync { [weak self] in
            var collections: [NftCollection] = []
            if let self, let storage = storage {

                for collection in storage.values {
                    collections.append(collection)
                }
            }
            if collections.count > 0 {
                return collections
            } else {
                return nil
            }
        }
    }
}

