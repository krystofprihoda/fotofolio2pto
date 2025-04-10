//
//  ReadFlaggedPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol ReadFlaggedPortfoliosUseCase {
    func execute() async throws -> [Portfolio]
    func execute(idOnly: Bool) -> [String]
}

public struct ReadFlaggedPortfoliosUseCaseImpl: ReadFlaggedPortfoliosUseCase {
    
    private let portfolioRepository: PortfolioRepository
    
    init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }
    
    public func execute() async throws -> [Portfolio] {
        try await portfolioRepository.readFlagged()
    }
    
    public func execute(idOnly: Bool) -> [String] {
        portfolioRepository.readFlaggedIds()
    }
}
