//
//  LoginWithCredentialsUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol LoginWithCredentialsUseCase {
    func execute(email: String, password: String) async throws -> UserAuthDetails
}

public struct LoginWithCredentialsUseCaseImpl: LoginWithCredentialsUseCase {
    
    private let authRepository: AuthRepository
    private let userRepository: UserRepository
    
    init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    public func execute(email: String, password: String) async throws -> UserAuthDetails {
        return try await authRepository.loginWithCredentials(email: email, password: password)
    }
}
