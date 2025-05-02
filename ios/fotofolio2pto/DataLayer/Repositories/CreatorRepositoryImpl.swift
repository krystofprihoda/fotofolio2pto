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
        guard let userId: String = encryptedStorage.read(.userId) else { throw AuthError.missingUserId }
        
        let body: [String: String] = [
            "userId": userId,
            "yearsOfExperience": String(yearsOfExperience)
        ]
        
        _ = try await network.request(endpoint: .creator, method: .POST, body: body, headers: nil, queryParams: nil, auth: true)
    }
    
    public func readCreator(id: String) async throws -> Creator {
        let netCreator: NETCreator = try await network.fetch(endpoint: .creatorById(id), method: .GET, body: nil, headers: nil, queryParams: nil, auth: true)
        return try netCreator.domainModel
    }
    
    public func readUserByCreatorId(creatorId: String) async throws -> User {
        let netUser: NETUser = try await network.fetch(endpoint: .userByCreatorId(creatorId), method: .GET, body: [:], headers: nil, queryParams: nil, auth: true)
        return try netUser.domainModel
    }
    
    public func readAllCreatorPortfolios(creatorId: String) async throws -> [Portfolio] {
        let netPortfolios: [NETPortfolio] = try await network.fetch(
            endpoint: .creatorPortfolio(creatorId: creatorId),
            method: .GET,
            body: [:],
            headers: nil,
            queryParams: nil,
            auth: true
        )
        return try netPortfolios.map { try $0.domainModel }
    }
    
    public func updateCreatorData(creatorId: String, yearsOfExperience: Int, profileDescription: String) async throws {
        let body: [String: String] = [
            "yearsOfExperience": String(yearsOfExperience),
            "description": profileDescription
        ]
        
        let _ = try await network.request(endpoint: .creatorById(creatorId), method: .PATCH, body: body, headers: nil, queryParams: nil, auth: true)
    }
}
