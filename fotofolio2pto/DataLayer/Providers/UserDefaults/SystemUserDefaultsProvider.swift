//
//  SystemUserDefaultsProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public struct SystemUserDefaultsProvider {
    public init() {}
}

extension SystemUserDefaultsProvider: UserDefaultsProvider {
    public func read<T>(_ key: UserDefaultsCoding) -> T? {
        return UserDefaults.standard.object(forKey: key.rawValue) as? T
    }
    
    public func update<T>(_ key: UserDefaultsCoding, value: T) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    public func read<T>(_ key: UserDefaultsCoding) -> [T]? {
        return UserDefaults.standard.array(forKey: key.rawValue) as? [T]
    }
    
    public func update<T>(_ key: UserDefaultsCoding, value: [T]) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    public func delete(_ key: UserDefaultsCoding) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    public func deleteAll() {
        for key in UserDefaultsCoding.allCases {
            delete(key)
        }
    }
}
