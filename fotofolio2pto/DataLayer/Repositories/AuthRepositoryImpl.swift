//
//  AuthRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public class AuthRepositoryImpl: AuthRepository {
    
    private let defaults: UserDefaultsProvider
    
    init(defaults: UserDefaultsProvider) {
        self.defaults = defaults
    }
    
    public func logout() {
        defaults.delete(.signedInUser)
        defaults.delete(.flagged)
    }
    
    public func loginWithCredentials(username: String, password: String) {
        defaults.update(.signedInUser, value: username)
    }
    
    public func getLoggedInUser() -> String? {
        return defaults.read(.signedInUser)
    }
}
