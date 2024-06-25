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
        register { AuthRepositoryImpl(defaults: resolve()) as AuthRepository }
        register { FeedRepositoryImpl(defaults: resolve()) as FeedRepository }
    }
}
