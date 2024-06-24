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
    private let authRepository = AuthRepositoryImpl(defaults: SystemUserDefaultsProvider())
    
    public func execute() {
        authRepository.logout()
    }
}
