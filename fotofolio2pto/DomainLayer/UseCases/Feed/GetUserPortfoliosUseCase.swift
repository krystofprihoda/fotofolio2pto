//
//  GetUserPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol GetUserPortfoliosUseCase {
    func execute(username: String) async throws -> [Portfolio]
}

public struct GetUserPortfoliosUseCaseImpl: GetUserPortfoliosUseCase {
    
    private let feedRepository: FeedRepository
    
    init(
        feedRepository: FeedRepository
    ) {
        self.feedRepository = feedRepository
    }
    
    public func execute(username: String) async throws -> [Portfolio] {
        try await feedRepository.getUserPortfolios(for: username)
    }
}
