//
//  Repositories+Injection.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation
import Resolver

public extension Resolver {
    static func registerRepositories() {
        register { AuthRepositoryImpl(defaults: resolve(), encryptedStorage: resolve(), authProvider: resolve()) as AuthRepository }
        register { UserRepositoryImpl(encryptedStorage: resolve(), network: resolve()) as UserRepository }
        register { CreatorRepositoryImpl(encryptedStorage: resolve(), network: resolve()) as CreatorRepository }
        register { PortfolioRepositoryImpl(defaults: resolve(), encryptedStorage: resolve(), network: resolve()) as PortfolioRepository }
        register { MessageRepositoryImpl(encryptedStorage: resolve(), network: resolve()) as MessageRepository }
    }
}
