//
//  ReadUserByIdUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.03.2025.
//


public protocol ReadUserByIdUseCase {
    func execute(id: String) async throws -> User
}

public struct ReadUserByIdUseCaseImpl: ReadUserByIdUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(id: String) async throws -> User {
        return try await userRepository.getUser(id: id)
    }
}
