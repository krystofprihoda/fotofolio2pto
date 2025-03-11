//
//  LoginWithCredentialsUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol LoginWithCredentialsUseCase {
    func execute(username: String, password: String) async throws
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
    
    public func execute(username: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        let _ = try await userRepository.getUserByUsername(username)
        authRepository.loginWithCredentials(username: username, password: password)
    }
}
