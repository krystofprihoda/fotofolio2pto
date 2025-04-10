//
//  RemovePortfolioUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 06.04.2025.
//

import Foundation

public protocol RemovePortfolioUseCase {
    func execute(id: String) async throws
}

public struct RemovePortfolioUseCaseImpl: RemovePortfolioUseCase {
    
    private let portfolioRepository: PortfolioRepository
    
    init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }
    
    public func execute(id: String) async throws {
        try await portfolioRepository.removePortfolio(id: id)
    }
}
