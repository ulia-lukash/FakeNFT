//
//  StorageManager.swift
//  FakeNFT
//
//  Created by Ivan Cherkashin on 18.02.2024.
//

import Foundation

public enum Keys: String {
    case sort
}

protocol StorageManagerProtocol {
    func set(_ object: Any?, forKey key: Keys)
    func int(forKey key: Keys) -> Int?
    func string(forKey key: Keys) -> String?
    func remove(forKey key: Keys)
}

final class StorageManager {
    
    private let userDefaults = UserDefaults.standard
    
    private func store(_ object: Any?, key: String) {
        userDefaults.setValue(object, forKey: key)
    }
    
    private func restore(forKey key: String) -> Any? {
        userDefaults.object(forKey: key)
    }
}

extension StorageManager: StorageManagerProtocol {
    func set(_ object: Any?, forKey key: Keys) {
        store(object, key: key.rawValue)
    }
    
    func int(forKey key: Keys) -> Int? {
        restore(forKey: key.rawValue) as? Int
    }
    
    func string(forKey key: Keys) -> String? {
        restore(forKey: key.rawValue) as? String
    }
    
    func remove(forKey key: Keys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
