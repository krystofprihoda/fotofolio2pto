//
//  AuthRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public struct UserAuthDetails {
    let uid: String
    let token: String
}

public class AuthRepositoryImpl: AuthRepository {
    
    private let defaults: UserDefaultsProvider
    private let authProvider: AuthProvider
    
    init(defaults: UserDefaultsProvider, authProvider: AuthProvider) {
        self.defaults = defaults
        self.authProvider = authProvider
    }
    
    public func logout() throws {
        try authProvider.logout()
        
        defaults.delete(.token)
        defaults.delete(.userId)
        defaults.delete(.flagged)
    }
    
    public func loginWithCredentials(email: String, password: String) async throws -> UserAuthDetails {
        let result = try await authProvider.login(email: email, password: password)
        let token = try await result.user.getIDToken()
        
        defaults.update(.token, value: token)
        defaults.update(.userId, value: result.user.uid)
        defaults.update(.email, value: result.user.email)
        
        return UserAuthDetails(uid: result.user.uid, token: token)
    }
    
    public func getLoggedInUser() -> String? {
        return defaults.read(.userId)
    }
    
    public func checkEmailAvailable(email: String) async throws {
        try await authProvider.checkEmailAvailable(email)
    }
    
    public func registerUser(email: String, password: String) async throws {
        let data = try await authProvider.registerUser(email: email, password: password)
        
        defaults.update(.userId, value: data.uid)
        defaults.update(.token, value: data.token)
    }
    
    public func readLastSignedInEmail() -> String {
        return defaults.read(.email) ?? ""
    }
}
