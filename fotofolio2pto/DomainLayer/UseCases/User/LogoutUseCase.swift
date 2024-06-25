//
//  LogoutUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol LogoutUseCase {
    func execute()
}

public struct LogoutUseCaseImpl: LogoutUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute() {
        authRepository.logout()
    }
}
