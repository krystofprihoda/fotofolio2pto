//
//  ReadLoggedInUserUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.06.2024.
//

import Foundation

public protocol ReadLoggedInUserUseCase {
    func execute() -> String?
}

public struct ReadLoggedInUserUseCaseImpl: ReadLoggedInUserUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func execute() -> String? {
        authRepository.readLoggedInUser()
    }
}
