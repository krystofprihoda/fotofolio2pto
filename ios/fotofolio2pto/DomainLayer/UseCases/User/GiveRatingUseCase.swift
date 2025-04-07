//
//  GiveRatingUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 07.04.2025.
//

public protocol GiveRatingUseCase {
    func execute(receiverId: String, rating: Int) async throws
}

public struct GiveRatingUseCaseImpl: GiveRatingUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(receiverId: String, rating: Int) async throws {
        try await userRepository.giveRatingToUser(receiverId: receiverId, rating: rating)
    }
}
