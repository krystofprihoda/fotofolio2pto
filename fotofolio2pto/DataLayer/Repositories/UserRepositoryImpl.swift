//
//  UserRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public class UserRepositoryImpl: UserRepository {
    
    private static var users = User.sampleData
    
    public func getUserByUsername(_ username: String) async throws -> User? {
        try await Task.sleep(for: .seconds(0.3))
        guard let user = UserRepositoryImpl.users.first(where: { user in
            user.username == username
        }) else { throw ObjectError.nonExistent }
        return user
    }
    
    public func getUsersFromUsernameQuery(query: String, type: SearchOption) async throws -> [User] {
        try await Task.sleep(for: .seconds(0.3))
        return UserRepositoryImpl.users.filter({ user in
            user.username.lowercased().hasPrefix(query.lowercased())
        })
    }
    
    public func getUsersFromLocationQuery(query: String, type: SearchOption) async throws -> [User] {
        try await Task.sleep(for: .seconds(0.3))
        return UserRepositoryImpl.users.filter({ user in
            user.location.lowercased().hasPrefix(query.lowercased())
        })
    }
}
