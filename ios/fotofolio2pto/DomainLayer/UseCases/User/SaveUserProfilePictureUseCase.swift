//
//  SaveUserProfilePictureUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 06.04.2025.
//

import UIKit

public protocol SaveUserProfilePictureUseCase {
    func execute(image: UIImage) async throws
}

public struct SaveUserProfilePictureUseCaseImpl: SaveUserProfilePictureUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(image: UIImage) async throws {
        return try await userRepository.saveUserProfilePicture(image: image)
    }
}
