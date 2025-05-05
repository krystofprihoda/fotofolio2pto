//
//  UpdatePortfolioUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 16.03.2025.
//

import Foundation

public protocol UpdatePortfolioUseCase {
    func execute(
        id: String,
        name: String,
        photos: [String],
        price: Price,
        description: String,
        category: [String]
    ) async throws -> Portfolio
}

public struct UpdatePortfolioUseCaseImpl: UpdatePortfolioUseCase {
    
    private let portfolioRepository: PortfolioRepository
    
    init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }
    
    public func execute(
        id: String,
        name: String,
        photos: [String],
        price: Price,
        description: String,
        category: [String]
    ) async throws -> Portfolio {
        return try await portfolioRepository
            .updatePortfolio(
                id: id,
                name: name,
                photos: photos,
                price: price,
                description: description,
                category: category
            )
    }
}
