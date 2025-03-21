//
//  GetUsersFromQueryUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol GetUsersFromQueryUseCase {
    func execute(query: String) async throws -> [User]
}

public struct GetUsersFromQueryUseCaseImpl: GetUsersFromQueryUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(query: String) async throws -> [User] {
        let usersByName = try await userRepository.getUsersFromUsernameQuery(query: query)
        let usersByLocation = try await userRepository.getUsersFromLocationQuery(query: query)
        let result = usersByName + usersByLocation
        return result
    }
    
    
}
