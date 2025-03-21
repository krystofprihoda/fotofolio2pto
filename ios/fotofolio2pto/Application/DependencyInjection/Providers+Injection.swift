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
        register { SystemUserDefaultsProvider() as UserDefaultsProvider }
    }
}
