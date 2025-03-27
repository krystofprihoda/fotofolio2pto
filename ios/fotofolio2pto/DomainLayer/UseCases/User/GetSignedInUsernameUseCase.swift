//
//  GetSignedInUsernameUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.03.2025.
//

public protocol GetSignedInUsernameUseCase {
    func execute() throws -> String
}

public struct GetSignedInUsernameUseCaseImpl: GetSignedInUsernameUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    
    public func execute() throws -> String {
        return try userRepository.getSignedInUsername()
    }
}
