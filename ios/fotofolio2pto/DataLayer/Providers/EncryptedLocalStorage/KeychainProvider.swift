//
//  KeychainProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 07.04.2025.
//

import Foundation
import KeychainAccess

public struct KeychainProvider {
    private let keychain: Keychain

    public init(service: String = Bundle.main.bundleIdentifier ?? "fotofolio2pto.keychain") {
        self.keychain = Keychain(service: service)
    }
}

extension KeychainProvider: EncryptedLocalStorageProvider {
    public func update(_ key: EncryptedLocalStorageCoding, value: String) {
        keychain[key.rawValue] = value
    }

    public func read(_ key: EncryptedLocalStorageCoding) -> String? {
        return keychain[key.rawValue]
    }

    public func delete(_ key: EncryptedLocalStorageCoding) {
        try? keychain.remove(key.rawValue)
    }

    public func deleteAll() {
        for key in EncryptedLocalStorageCoding.allCases {
            try? keychain.remove(key.rawValue)
        }
    }
}
