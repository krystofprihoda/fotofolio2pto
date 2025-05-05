//
//  SaveUserDataUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.03.2025.
//

public protocol SaveUserDataUseCase {
    func execute(
        username: String,
        email: String,
        fullName: String,
        location: String,
        profilePicture: String
    ) async throws
}

public struct SaveUserDataUseCaseImpl: SaveUserDataUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(username: String, email: String, fullName: String, location: String, profilePicture: String) async throws {
        return try await userRepository
            .createUser(
                username: username,
                email: email,
                fullName: fullName,
                location: location,
                profilePicture: profilePicture
            )
    }
}
