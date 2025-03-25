//
//  RegisterUserAndGetTokenUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.03.2025.
//

public struct RegisterData {
    let uid: String
    let token: String
}

public protocol RegisterUserAndGetTokenUseCase {
    func execute(email: String, password: String) async throws -> RegisterData
}

public struct RegisterUserAndGetTokenUseCaseImpl: RegisterUserAndGetTokenUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute(email: String, password: String) async throws -> RegisterData {
        return try await authRepository.registerUserAndGetToken(email: email, password: password)
    }
}
