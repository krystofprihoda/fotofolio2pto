//
//  ReadLastSignedInEmailUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.03.2025.
//

public protocol ReadLastSignedInEmailUseCase {
    func execute() -> String
}

public struct ReadLastSignedInEmailUseCaseImpl: ReadLastSignedInEmailUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    
    public func execute() -> String {
        return authRepository.readLastSignedInEmail()
    }
}
