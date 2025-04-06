//
//  UpdateCreatorDataUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 06.04.2025.
//

public protocol UpdateCreatorDataUseCase {
    func execute(creatorId: String, yearsOfExperience: Int, profileDescription: String) async throws
}

public struct UpdateCreatorDataUseCaseImpl: UpdateCreatorDataUseCase {
    
    private let creatorRepository: CreatorRepository
    
    init(creatorRepository: CreatorRepository) {
        self.creatorRepository = creatorRepository
    }
    
    public func execute(creatorId: String, yearsOfExperience: Int, profileDescription: String) async throws {
        try await creatorRepository.updateCreatorData(creatorId: creatorId, yearsOfExperience: yearsOfExperience, profileDescription: profileDescription)
    }
}
