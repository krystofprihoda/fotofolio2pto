//
//  FlagPortfolioUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol FlagPortfolioUseCase {
    func execute(id: Int) throws
}

public struct FlagPortfolioUseCaseImpl: FlagPortfolioUseCase {
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute(id: Int) throws {
        try feedRepository.addToFlagged(portfolioId: id)
    }
}
