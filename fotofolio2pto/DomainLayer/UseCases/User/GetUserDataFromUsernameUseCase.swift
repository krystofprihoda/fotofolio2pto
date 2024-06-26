//
//  GetUserDataFromUsernameUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol GetUserDataFromUsernameUseCase {
    func execute(_ user: String) async throws -> User?
}

public struct GetUserDataFromUsernameUseCaseImpl: GetUserDataFromUsernameUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(_ user: String) async throws -> User? {
        try await userRepository.getUserByUsername(user)
    }
    
    
}
