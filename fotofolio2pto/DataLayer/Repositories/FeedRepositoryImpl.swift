//
//  FeedRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public class FeedRepositoryImpl: FeedRepository {
    
    private static var portfolios: [Portfolio] = Portfolio.sampleData
    
    private let defaults: UserDefaultsProvider
    
    init(defaults: UserDefaultsProvider) {
        self.defaults = defaults
    }
    
    public func getAll() async throws -> [Portfolio] {
        try await Task.sleep(for: .seconds(1))
        return FeedRepositoryImpl.portfolios
    }
    
    public func getAll(sorted: SortByEnum) async throws -> [Portfolio] {
        try await Task.sleep(for: .seconds(1))
        switch sorted {
        case .date: return FeedRepositoryImpl.portfolios.sorted(by: { $0.timestamp > $1.timestamp })
        case .rating:
            return FeedRepositoryImpl.portfolios.sorted(by: {
                return $0.author.calculateRating() > $1.author.calculateRating()
            })
        }
    }
    
    public func getById(_ id: Int) async throws -> Portfolio {
        try await Task.sleep(for: .seconds(0.5))
        guard let folio = FeedRepositoryImpl.portfolios.first(where: { $0.id == id }) else { throw ObjectError.nonExistent }
        return folio
    }
    
    public func addToFlagged(portfolioId: Int) throws {
//        guard !FeedRepositoryImpl.flagged.contains(where: { $0 == portfolioId }) else { return }
//        FeedRepositoryImpl.flagged.append(portfolioId)
        
        var flagged = getFlaggedIds()
        guard !flagged.contains(where: { $0 == portfolioId }) else { return }
        flagged.append(portfolioId)
        defaults.update(.flagged, value: flagged)
    }
    
    public func removeFromFlagged(portfolioId: Int) throws {
//        FeedRepositoryImpl.flagged.removeAll(where: { $0 == portfolioId })
        
        var flagged = getFlaggedIds()
        flagged.removeAll(where: { $0 == portfolioId })
        defaults.update(.flagged, value: flagged)
    }
    
    public func getFlagged() async throws -> [Portfolio] {
        let flagged = getFlaggedIds()
        return try await flagged.asyncMap({ id in
            try await getById(id)
        })
    }
        
    public func getFlaggedIds() -> [Int] {
        return defaults.read(.flagged) ?? []
    }
    
    public func removeAllFlagged() throws {
        defaults.delete(.flagged)
    }
}
