//
//  CreatorRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.03.2025.
//

import Foundation

public class CreatorRepositoryImpl: CreatorRepository {
    
    private let encryptedStorage: EncryptedLocalStorageProvider
    private let network: NetworkProvider
    
    init(encryptedStorage: EncryptedLocalStorageProvider, network: NetworkProvider) {
        self.encryptedStorage = encryptedStorage
        self.network = network
    }
    
    public func createCreator(yearsOfExperience: Int) async throws {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        guard let userId: String = encryptedStorage.read(.userId) else { throw AuthError.missingUserId }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: String] = [
            "userId": userId,
            "yearsOfExperience": String(yearsOfExperience)
        ]
        
        _ = try await network.request(endpoint: .creator, method: .POST, body: body, headers: headers, queryParams: nil)
    }
    
    public func readCreator(id: String) async throws -> Creator {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let netCreator: NETCreator = try await network.fetch(endpoint: .creatorById(id), method: .GET, body: nil, headers: headers, queryParams: nil)
        return try netCreator.domainModel
    }
    
    public func readUserByCreatorId(creatorId: String) async throws -> User {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let netUser: NETUser = try await network.fetch(endpoint: .userByCreatorId(creatorId), method: .GET, body: [:], headers: headers, queryParams: nil)
        return try netUser.domainModel
    }
    
    public func readAllCreatorPortfolios(creatorId: String) async throws -> [Portfolio] {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let netPortfolios: [NETPortfolio] = try await network.fetch(
            endpoint: .creatorPortfolio(creatorId: creatorId),
            method: .GET,
            body: [:],
            headers: headers,
            queryParams: nil
        )
        return try netPortfolios.map { try $0.domainModel }
    }
    
    public func updateCreatorData(creatorId: String, yearsOfExperience: Int, profileDescription: String) async throws {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: String] = [
            "yearsOfExperience": String(yearsOfExperience),
            "description": profileDescription
        ]
        
        let _ = try await network.request(endpoint: .creatorById(creatorId), method: .PATCH, body: body, headers: headers, queryParams: nil)
    }
}
