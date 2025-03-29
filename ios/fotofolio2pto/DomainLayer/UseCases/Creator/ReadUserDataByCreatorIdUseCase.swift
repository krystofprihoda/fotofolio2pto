//
//  ReadUserDataByCreatorIdUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 29.03.2025.
//

public protocol ReadUserDataByCreatorIdUseCase {
    func execute(creatorId: String) async throws -> User
}

public struct ReadUserDataByCreatorIdUseCaseImpl: ReadUserDataByCreatorIdUseCase {
    
    private let creatorRepository: CreatorRepository
    
    init(creatorRepository: CreatorRepository) {
        self.creatorRepository = creatorRepository
    }
    
    public func execute(creatorId: String) async throws -> User {
        return try await creatorRepository.readUserByCreatorId(creatorId: creatorId)
    }
}
