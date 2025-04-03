//
//  UserRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public class UserRepositoryImpl: UserRepository {
    
    private let defaults: UserDefaultsProvider
    private let network: NetworkProvider
    
    init(defaults: UserDefaultsProvider, network: NetworkProvider) {
        self.defaults = defaults
        self.network = network
    }
    
    private static var users = User.sampleData
    
    public func getUsersFromQuery(query: String) async throws -> [User] {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let queryParams = query.isEmpty ? nil : ["query": query]
        
        let users: [User] = try await network.fetch(
            endpoint: .user,
            method: .GET,
            body: nil,
            headers: headers,
            queryParams: queryParams
        )
        return users
    }
    
    public func isUsernameTaken(_ username: String) async throws {
        try await Task.sleep(for: .seconds(0.3))
        guard let _ = UserRepositoryImpl.users.first(where: { user in
            user.username == username
        }) else { return }
        
        throw ObjectError.usernameAlreadyTaken
    }
    
    public func createUser(username: String, email: String, fullName: String, location: String, profilePicture: String) async throws {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        guard let userId: String = defaults.read(.userId) else { throw AuthError.missingUserId }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: String] = [
            "userId": userId,
            "username": username,
            "email": email,
            "fullName": fullName,
            "location": location,
            "profilePicture": profilePicture
        ]
        
        _ = try await network.request(
                endpoint: .user,
                method: .POST,
                body: body,
                headers: headers,
                queryParams: nil
            )
    }
    
    public func getUser(id: String) async throws -> User {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let user: User = try await network.fetch(
            endpoint: .userById(id),
            method: .GET,
            body: [:],
            headers: headers,
            queryParams: nil
        )
        return user
    }
    
    public func saveSignedInUsername(_ username: String) {
        defaults.update(.username, value: username)
    }
    
    public func getSignedInUsername() throws -> String {
        guard let username: String = defaults.read(.username) else { throw ObjectError.nonExistent }
        return username
    }
}
