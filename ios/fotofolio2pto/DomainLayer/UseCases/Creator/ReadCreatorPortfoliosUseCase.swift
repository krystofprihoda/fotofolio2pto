//
//  ReadCreatorPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol ReadCreatorPortfoliosUseCase {
    func execute(creatorId: String) async throws -> [Portfolio]
}

public struct ReadCreatorPortfoliosUseCaseImpl: ReadCreatorPortfoliosUseCase {
    
    private let creatorRepository: CreatorRepository
    
    init(
        creatorRepository: CreatorRepository
    ) {
        self.creatorRepository = creatorRepository
    }
    
    public func execute(creatorId: String) async throws -> [Portfolio] {
        try await creatorRepository.readAllCreatorPortfolios(for: creatorId)
    }
}
