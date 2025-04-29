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
    
    private let defaults: LocalStorageProvider
    private let encryptedStorage: EncryptedLocalStorageProvider
    private let authProvider: AuthProvider
    
    init(defaults: LocalStorageProvider, encryptedStorage: EncryptedLocalStorageProvider, authProvider: AuthProvider) {
        self.defaults = defaults
        self.encryptedStorage = encryptedStorage
        self.authProvider = authProvider
    }
    
    public func logout() throws {
        try authProvider.logout()
        
        encryptedStorage.delete(.token)
        encryptedStorage.delete(.userId)
        
        defaults.delete(.flagged)
    }
    
    public func loginWithCredentials(email: String, password: String) async throws -> UserAuthDetails {
        let result = try await authProvider.login(email: email, password: password)
        let token = try await result.user.getIDToken()
        
        encryptedStorage.update(.token, value: token)
        encryptedStorage.update(.userId, value: result.user.uid)
        defaults.update(.email, value: result.user.email)
        
        return UserAuthDetails(uid: result.user.uid, token: token)
    }
    
    public func readLoggedInUser() -> String? {
        return encryptedStorage.read(.userId)
    }
    
    public func checkEmailAvailable(email: String) async throws {
        try await authProvider.checkEmailAvailable(email)
    }
    
    public func registerUser(email: String, password: String) async throws {
        let data = try await authProvider.registerUser(email: email, password: password)
        
        encryptedStorage.update(.userId, value: data.uid)
        encryptedStorage.update(.token, value: data.token)
        
        guard let email = data.email else { return }
        defaults.update(.email, value: email)
    }
    
    public func readLastSignedInEmail() -> String {
        return defaults.read(.email) ?? ""
    }
}
