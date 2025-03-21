//
//  GetFilteredPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.06.2024.
//

import Foundation

public protocol GetFilteredPortfoliosUseCase {
    func execute(filter: [String]) async throws -> [Portfolio]
}

public struct GetFilteredPortfoliosUseCaseImpl: GetFilteredPortfoliosUseCase {
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute(filter: [String]) async throws -> [Portfolio] {
        try await feedRepository.getFilteredPortfolios(filter: filter)
    }
}
