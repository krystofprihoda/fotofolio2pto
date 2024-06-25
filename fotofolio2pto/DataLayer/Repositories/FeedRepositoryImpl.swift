//
//  FeedRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public class FeedRepositoryImpl: FeedRepository {
    
    private static var portfolios: [Portfolio] = Portfolio.sampleData
    private static var flagged: [UUID] = []
    
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
    
    public func getById(_ id: UUID) async throws -> Portfolio {
        try await Task.sleep(for: .seconds(0.5))
        guard let folio = FeedRepositoryImpl.portfolios.first(where: { $0.id == id }) else { throw ObjectError.nonExistent }
        return folio
    }
    
    public func addToFlagged(portfolioId: UUID) throws {
        guard !FeedRepositoryImpl.flagged.contains(where: { $0 == portfolioId }) else { return }
        FeedRepositoryImpl.flagged.append(portfolioId)
        
//        let flagged: FlaggedPortfolios? = defaults.read(.flagged) ?? nil
//       guard let flagged else { throw ObjectError.nonExistent }
//        var toBeFlagged: [UUID] = flagged?.portfolios ?? []
//        toBeFlagged.append(portfolioId)
//        defaults.update(.flagged, value: FlaggedPortfolios(portfolios: [portfolioId]))
    }
    
    public func removeFromFlagged(portfolioId: UUID) throws {
        FeedRepositoryImpl.flagged.removeAll(where: { $0 == portfolioId })
        
//        let flagged: FlaggedPortfolios? = defaults.read(.flagged) ?? nil
//        guard let flagged else { throw ObjectError.nonExistent }
//        var updatedFlagged: [UUID] = flagged.portfolios
//        updatedFlagged.removeAll(where: { $0 == portfolioId })
//        defaults.update(.flagged, value: FlaggedPortfolios(portfolios: updatedFlagged))
    }
    
    public func getFlagged() async throws -> [Portfolio] {
        return try await FeedRepositoryImpl.flagged.asyncMap({ id in
            try await getById(id)
        })
    }
    
    public func getFlaggedIds() -> [UUID] {
        return FeedRepositoryImpl.flagged
    }
    
    public func removeAllFlagged() throws {
        FeedRepositoryImpl.flagged.removeAll()
    }
}
