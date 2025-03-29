//
//  UpdatePortfolioUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 16.03.2025.
//

import Foundation

public protocol UpdatePortfolioUseCase {
    func execute(id: String, name: String, photos: [IImage], description: String, category: [String]) async throws
}

public struct UpdatePortfolioUseCaseImpl: UpdatePortfolioUseCase {
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute(id: String, name: String, photos: [IImage], description: String, category: [String]) async throws {
        try await feedRepository.updatePortfolio(id: id, name: name, photos: photos, description: description, category: category)
    }
}
