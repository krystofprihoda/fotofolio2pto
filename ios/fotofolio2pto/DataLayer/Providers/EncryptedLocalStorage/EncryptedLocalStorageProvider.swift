//
//  EncryptedLocalStorageProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 07.04.2025.
//

import Foundation

public enum EncryptedLocalStorageCoding: String, CaseIterable {
    case userId
    case token
}

public protocol EncryptedLocalStorageProvider {

    /// Create or update the given key with a given value
    func update(_ key: EncryptedLocalStorageCoding, value: String)

    /// Try to read a value for the given key
    func read(_ key: EncryptedLocalStorageCoding) -> String?

    /// Delete value for the given key
    func delete(_ key: EncryptedLocalStorageCoding)

    /// Delete all records
    func deleteAll()
}
