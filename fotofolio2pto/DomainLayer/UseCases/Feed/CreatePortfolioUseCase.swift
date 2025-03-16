//
//  CreatePortfolioUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import Foundation

public protocol CreatePortfolioUseCase {
    func execute(username: String, name: String, photos: [IImage], description: String, tags: [String]) async throws
}

public struct CreatePortfolioUseCaseImpl: CreatePortfolioUseCase {
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute(username: String, name: String, photos: [IImage], description: String, tags: [String]) async throws {
        try await feedRepository.createPortfolio(username: username, name: name, photos: photos, description: description, tags: tags)
    }
}
