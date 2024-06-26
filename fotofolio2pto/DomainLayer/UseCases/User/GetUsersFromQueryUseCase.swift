//
//  GetUsersFromQueryUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol GetUsersFromQueryUseCase {
    func execute(query: String, type: SearchOption) async throws -> [User]
}

public struct GetUsersFromQueryUseCaseImpl: GetUsersFromQueryUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(query: String, type: SearchOption) async throws -> [User] {
        switch type {
        case .username: return try await userRepository.getUsersFromUsernameQuery(query: query, type: type)
        case .location: return try await userRepository.getUsersFromLocationQuery(query: query, type: type)
        }
    }
    
    
}
