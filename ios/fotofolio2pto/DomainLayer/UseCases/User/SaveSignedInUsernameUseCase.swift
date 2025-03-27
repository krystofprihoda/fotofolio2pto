//
//  SaveSignedInUsernameUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.03.2025.
//

public protocol SaveSignedInUsernameUseCase {
    func execute(username: String)
}

public struct SaveSignedInUsernameUseCaseImpl: SaveSignedInUsernameUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    
    public func execute(username: String) {
        userRepository.saveSignedInUsername(username)
    }
}
