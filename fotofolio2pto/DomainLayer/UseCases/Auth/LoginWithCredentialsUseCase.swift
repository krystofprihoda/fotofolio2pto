//
//  LoginWithCredentialsUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol LoginWithCredentialsUseCase {
    func execute(username: String, password: String)
}

public struct LoginWithCredentialsUseCaseImpl: LoginWithCredentialsUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute(username: String, password: String) {
        authRepository.loginWithCredentials(username: username, password: password)
    }
}
