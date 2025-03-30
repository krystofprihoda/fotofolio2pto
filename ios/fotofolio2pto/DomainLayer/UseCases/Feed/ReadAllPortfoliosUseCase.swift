//
//  ReadAllPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public enum SortByEnum {
    case date
    case rating
}

public protocol ReadAllPortfoliosUseCase {
    func execute(categories: [String]?, sortBy: SortByEnum?) async throws -> [Portfolio]
}

public struct ReadAllPortfoliosUseCaseImpl: ReadAllPortfoliosUseCase {
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute(categories: [String]?, sortBy: SortByEnum?) async throws -> [Portfolio] {
        try await feedRepository.readAll(categories: categories, sortBy: sortBy)
    }
}
