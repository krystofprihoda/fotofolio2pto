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
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute() async throws -> [Portfolio] {
        try await feedRepository.readFlagged()
    }
    
    public func execute(idOnly: Bool) -> [String] {
        feedRepository.readFlaggedIds()
    }
}
