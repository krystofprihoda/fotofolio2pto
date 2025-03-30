//
//  CreatorRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.03.2025.
//

import Foundation

public class CreatorRepositoryImpl: CreatorRepository {
    
    private let defaults: UserDefaultsProvider
    private let network: NetworkProvider
    
    init(defaults: UserDefaultsProvider, network: NetworkProvider) {
        self.defaults = defaults
        self.network = network
    }
    
    public func createCreator(yearsOfExperience: Int) async throws {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        guard let userId: String = defaults.read(.userId) else { throw AuthError.missingUserId }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: String] = [
            "userId": userId,
            "yearsOfExperience": String(yearsOfExperience),
            "description": ""
        ]
        
        _ = try await network.request(endpoint: .creator, method: .POST, body: body, headers: headers, queryParams: nil)
    }
    
    public func readCreator(id: String) async throws -> Creator {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let creator: Creator = try await network.fetch(endpoint: .creatorById(id), method: .GET, body: nil, headers: headers, queryParams: nil)
        print(creator)
        return creator
    }
    
    public func readUserByCreatorId(creatorId: String) async throws -> User {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let user: User = try await network.fetch(endpoint: .userByCreatorId(creatorId), method: .GET, body: [:], headers: headers, queryParams: nil)
        print(user)
        return user
    }
    
    public func readAllCreatorPortfolios(for: String) async throws -> [Portfolio] {
        return []
    }
}
