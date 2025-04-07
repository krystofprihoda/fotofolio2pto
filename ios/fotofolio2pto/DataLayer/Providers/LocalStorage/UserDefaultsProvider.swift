//
//  UserDefaultsProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public struct UserDefaultsProvider {
    public init() {}
}

extension UserDefaultsProvider: LocalStorageProvider {
    public func read<T>(_ key: LocalStorageCoding) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
    
    public func update<T>(_ key: LocalStorageCoding, value: T) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    public func read<T>(_ key: LocalStorageCoding) -> [T]? {
        return UserDefaults.standard.array(forKey: key.rawValue) as? [T]
    }
    
    public func update<T>(_ key: LocalStorageCoding, value: [T]) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    public func delete(_ key: LocalStorageCoding) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    public func deleteAll() {
        for key in LocalStorageCoding.allCases {
            delete(key)
        }
    }
}
