//
//  GetFlaggedPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol GetFlaggedPortfoliosUseCase {
    func execute() async throws -> [Portfolio]
    func execute(idOnly: Bool) -> [UUID]
}

public struct GetFlaggedPortfoliosUseCaseImpl: GetFlaggedPortfoliosUseCase {
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute() async throws -> [Portfolio] {
        try await feedRepository.getFlagged()
    }
    
    public func execute(idOnly: Bool) -> [UUID] {
        feedRepository.getFlaggedIds()
    }
}
