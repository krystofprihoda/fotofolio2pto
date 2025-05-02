//
//  Providers+Injection.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation
import Resolver

public extension Resolver {
    static func registerProviders() {
        register { UserDefaultsProvider() as LocalStorageProvider }
        register { KeychainProvider() as EncryptedLocalStorageProvider }
        register { FirebaseProvider() as AuthProvider }
        register { DefaultNetworkProvider(encryptedStorage: resolve()) as NetworkProvider }
    }
}
