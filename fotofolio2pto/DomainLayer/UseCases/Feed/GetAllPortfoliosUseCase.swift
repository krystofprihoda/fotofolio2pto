//
//  GetAllPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public enum SortByEnum {
    case date
    case rating
}

public protocol GetAllPortfoliosUseCase {
    func execute() async throws -> [Portfolio]
    func execute(sortBy: SortByEnum) async throws -> [Portfolio]
}

public struct GetAllPortfoliosUseCaseImpl: GetAllPortfoliosUseCase {
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute() async throws -> [Portfolio] {
        try await feedRepository.getAll()
    }
    
    public func execute(sortBy: SortByEnum) async throws -> [Portfolio] {
        try await feedRepository.getAll(sorted: sortBy)
    }
}
