//
//  SignOutUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol SignOutUseCase {
    func execute() throws
}

public struct SignOutUseCaseImpl: SignOutUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute() throws {
        try authRepository.logout()
    }
}
