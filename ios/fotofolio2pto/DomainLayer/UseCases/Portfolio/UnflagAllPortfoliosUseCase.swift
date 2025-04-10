//
//  UnflagAllPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.06.2024.
//

import Foundation

public protocol UnflagAllPortfoliosUseCase {
    func execute()
}

public struct UnflagAllPortfoliosUseCaseImpl: UnflagAllPortfoliosUseCase {
    
    private let portfolioRepository: PortfolioRepository
    
    init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }
    
    public func execute() {
        portfolioRepository.removeAllFlagged()
    }
}
