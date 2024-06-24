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
    
    // Resolver solves this later
    private let authRepository: AuthRepository = AuthRepositoryImpl(defaults: SystemUserDefaultsProvider())
    
//    init(authRepository: AuthRepository) {
//        self.authRepository = authRepository
//    }
    
    public func execute(username: String, password: String) {
        authRepository.loginWithCredentials(username: username, password: password)
    }
}
