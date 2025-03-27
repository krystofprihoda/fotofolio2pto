//
//  CheckUsernameAvailableUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 07.03.2025.
//


import Foundation

public protocol CheckUsernameAvailableUseCase {
    func execute(_ username: String) async throws
}

public struct CheckUsernameAvailableUseCaseImpl: CheckUsernameAvailableUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(_ username: String) async throws {
        return
        try await userRepository.isUsernameTaken(username)
    }
}
