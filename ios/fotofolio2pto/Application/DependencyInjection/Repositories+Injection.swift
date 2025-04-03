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
        register { AuthRepositoryImpl(defaults: resolve(), authProvider: resolve()) as AuthRepository }
        register { UserRepositoryImpl(defaults: resolve(), network: resolve()) as UserRepository }
        register { CreatorRepositoryImpl(defaults: resolve(), network: resolve()) as CreatorRepository }
        register { FeedRepositoryImpl(defaults: resolve(), network: resolve()) as FeedRepository }
        register { MessageRepositoryImpl(defaults: resolve(), network: resolve()) as MessageRepository }
    }
}
