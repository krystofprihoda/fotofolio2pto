//
//  UnflagPortfolioUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol UnflagPortfolioUseCase {
    func execute(id: String)
}

public struct UnflagPortfolioUseCaseImpl: UnflagPortfolioUseCase {
    
    private let portfolioRepository: PortfolioRepository
    
    init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }
    
    public func execute(id: String) {
        portfolioRepository.removeFromFlagged(portfolioId: id)
    }
}
