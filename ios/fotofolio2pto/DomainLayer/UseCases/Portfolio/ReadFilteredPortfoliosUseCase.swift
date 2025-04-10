//
//  ReadFilteredPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.06.2024.
//

import Foundation

public protocol ReadFilteredPortfoliosUseCase {
    func execute(filter: [String]) async throws -> [Portfolio]
}

public struct ReadFilteredPortfoliosUseCaseImpl: ReadFilteredPortfoliosUseCase {
    
    private let portfolioRepository: PortfolioRepository
    
    init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }
    
    public func execute(filter: [String]) async throws -> [Portfolio] {
        try await portfolioRepository.readAll(categories: filter, sortBy: nil)
    }
}
