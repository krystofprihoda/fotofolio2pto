//
//  FlagPortfolioUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol FlagPortfolioUseCase {
    func execute(id: String)
}

public struct FlagPortfolioUseCaseImpl: FlagPortfolioUseCase {
    
    private let portfolioRepository: PortfolioRepository
    
    init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }
    
    public func execute(id: String) {
        portfolioRepository.addToFlagged(portfolioId: id)
    }
}
