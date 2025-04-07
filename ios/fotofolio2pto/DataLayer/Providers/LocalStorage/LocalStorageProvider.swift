//
//  LocalStorageProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public enum LocalStorageCoding: String, CaseIterable {
    case email
    case flagged
}

public protocol LocalStorageProvider {

    /// Create or update the given key with a given value
    func update<T>(_ key: LocalStorageCoding, value: T)

    /// Try to read a value for the given key
    func read<T>(_ key: LocalStorageCoding) -> T?

    /// Delete value for the given key
    func delete(_ key: LocalStorageCoding)

    /// Delete all records
    func deleteAll()
}
