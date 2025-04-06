//
//  UpdateUserDataUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 06.04.2025.
//

public protocol UpdateUserDataUseCase {
    func execute(location: String) async throws
}

public struct UpdateUserDataUseCaseImpl: UpdateUserDataUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(location: String) async throws {
        return try await userRepository.updateUserData(location: location)
    }
}
