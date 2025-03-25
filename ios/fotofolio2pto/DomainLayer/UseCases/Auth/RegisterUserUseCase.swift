//
//  RegisterUserUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.03.2025.
//

public struct RegisterData {
    let uid: String
    let token: String
}

public protocol RegisterUserUseCase {
    func execute(email: String, password: String) async throws
}

public struct RegisterUserUseCaseImpl: RegisterUserUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute(email: String, password: String) async throws {
        try await authRepository.registerUser(email: email, password: password)
    }
}
