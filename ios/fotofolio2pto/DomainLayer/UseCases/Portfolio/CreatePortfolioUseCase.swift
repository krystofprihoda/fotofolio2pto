//
//  CreatePortfolioUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import Foundation

public protocol CreatePortfolioUseCase {
    func execute(
        creatorId: String,
        name: String,
        photos: [IImage],
        price: Price,
        description: String,
        category: [String]
    ) async throws
}

public struct CreatePortfolioUseCaseImpl: CreatePortfolioUseCase {
    
    private let portfolioRepository: PortfolioRepository
    
    init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }
    
    public func execute(
        creatorId: String,
        name: String,
        photos: [IImage],
        price: Price,
        description: String,
        category: [String]
    ) async throws {
        try await portfolioRepository
            .createPortfolio(
                creatorId: creatorId,
                name: name,
                photos: photos,
                price: price,
                description: description,
                category: category
            )
    }
}
