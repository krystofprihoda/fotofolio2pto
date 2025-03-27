//
//  GetCreatorDataUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.03.2025.
//

public protocol GetCreatorDataUseCase {
    func execute(id: String) async throws -> Creator
}

public struct GetCreatorDataUseCaseImpl: GetCreatorDataUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(id: String) async throws -> Creator {
        return try await userRepository.getCreator(id: id)
    }
}
