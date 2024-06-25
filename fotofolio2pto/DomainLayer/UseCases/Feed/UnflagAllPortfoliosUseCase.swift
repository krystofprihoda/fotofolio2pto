//
//  UnflagAllPortfoliosUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.06.2024.
//

import Foundation

public protocol UnflagAllPortfoliosUseCase {
    func execute() throws
}

public struct UnflagAllPortfoliosUseCaseImpl: UnflagAllPortfoliosUseCase {
    
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute() throws {
        try feedRepository.removeAllFlagged()
    }
}
