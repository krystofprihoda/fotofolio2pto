//
//  CreateCreatorDataUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.03.2025.
//

public protocol CreateCreatorDataUseCase {
    func execute(yearsOfExperience: Int) async throws
}

public struct CreateCreatorDataUseCaseImpl: CreateCreatorDataUseCase {
    
    private let creatorRepository: CreatorRepository
    
    init(creatorRepository: CreatorRepository) {
        self.creatorRepository = creatorRepository
    }
    
    public func execute(yearsOfExperience: Int) async throws {
        try await creatorRepository.createCreator(yearsOfExperience: yearsOfExperience)
    }
}
