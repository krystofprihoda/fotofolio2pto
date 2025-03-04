//
//  UserDefaultsProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public enum UserDefaultsCoding: String, CaseIterable {
    case signedInUser
    case flagged
}

public protocol UserDefaultsProvider {

    /// Create or update the given key with a given value
    func update<T>(_ key: UserDefaultsCoding, value: T)

    /// Try to read a value for the given key
    func read<T>(_ key: UserDefaultsCoding) -> T?

    /// Delete value for the given key
    func delete(_ key: UserDefaultsCoding)

    /// Delete all records
    func deleteAll()
}
