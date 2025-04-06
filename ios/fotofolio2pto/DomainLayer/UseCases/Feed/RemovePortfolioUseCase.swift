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
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute(id: String) async throws {
        try await feedRepository.removePortfolio(id: id)
    }
}
