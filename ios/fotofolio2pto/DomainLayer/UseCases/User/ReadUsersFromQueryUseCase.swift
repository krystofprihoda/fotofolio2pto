//
//  ReadUsersFromQueryUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol ReadUsersFromQueryUseCase {
    func execute(query: String) async throws -> [User]
}

public struct ReadUsersFromQueryUseCaseImpl: ReadUsersFromQueryUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(query: String) async throws -> [User] {
        return try await userRepository.getUsersFromUsernameQuery(query: query)
    }
    
    
}
