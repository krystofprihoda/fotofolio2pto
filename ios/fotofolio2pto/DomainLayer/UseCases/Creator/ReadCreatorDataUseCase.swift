//
//  ReadCreatorDataUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.03.2025.
//

public protocol ReadCreatorDataUseCase {
    func execute(id: String) async throws -> Creator
}

public struct ReadCreatorDataUseCaseImpl: ReadCreatorDataUseCase {
    
    private let creatorRepository: CreatorRepository
    
    init(creatorRepository: CreatorRepository) {
        self.creatorRepository = creatorRepository
    }
    
    public func execute(id: String) async throws -> Creator {
        return try await creatorRepository.getCreator(id: id)
    }
}
