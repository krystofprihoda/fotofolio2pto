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
    private let userRepository: UserRepository
    
    init(defaults: UserDefaultsProvider, userRepository: UserRepository) {
        self.defaults = defaults
        self.userRepository = userRepository
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
                return $0.author.averageRating > $1.author.averageRating
            })
        }
    }
    
    public func getById(_ id: Int) async throws -> Portfolio {
        try await Task.sleep(for: .seconds(0.5))
        guard let folio = FeedRepositoryImpl.portfolios.first(where: { $0.id == id }) else { throw ObjectError.nonExistent }
        return folio
    }
    
    public func addToFlagged(portfolioId: Int) throws {
        var flagged = getFlaggedIds()
        guard !flagged.contains(where: { $0 == portfolioId }) else { return }
        flagged.append(portfolioId)
        defaults.update(.flagged, value: flagged)
    }
    
    public func removeFromFlagged(portfolioId: Int) throws {
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
    
    public func getFilteredPortfolios(filter: [String]) async throws -> [Portfolio] {
        try await Task.sleep(for: .seconds(0.5))
        
        guard !filter.isEmpty else { return FeedRepositoryImpl.portfolios }
        return FeedRepositoryImpl.portfolios.filter({ portfolio in
            portfolio.tags.contains(where: { tag in
                filter.contains(where: { filterTag in
                    tag == filterTag
                })
            })
        })
    }
    
    public func getUserPortfolios(for username: String) async throws -> [Portfolio] {
        return FeedRepositoryImpl.portfolios.filter({ portfolio in
            portfolio.author.username == username
        })
    }
    
    public func createPortfolio(username: String, name: String, photos: [IImage], description: String, tags: [String]) async throws {
        try await Task.sleep(for: .seconds(0.5))
        let latestId = FeedRepositoryImpl.portfolios.last?.id ?? 0
        guard let author = try await userRepository.getUserByUsername(username) else { throw ObjectError.nonExistent }
        let new = Portfolio(id: latestId + 1, author: author, creator: .dummy2, name: name, photos: photos, description: description, tags: tags, timestamp: .now)
        FeedRepositoryImpl.portfolios.append(new)
    }
    
    public func updatePortfolio(id: Int, name: String, photos: [IImage], description: String, tags: [String]) async throws {
        try await Task.sleep(for: .seconds(0.5))
        
        guard let old = FeedRepositoryImpl.portfolios.first(where: { $0.id == id }) else { throw ObjectError.nonExistent }
        FeedRepositoryImpl.portfolios.removeAll(where: { $0.id == id })
        
        let new = Portfolio(id: old.id, author: old.author, creator: old.creator, name: name, photos: photos, description: description, tags: tags, timestamp: .now)
        FeedRepositoryImpl.portfolios.append(new)
    }
}
