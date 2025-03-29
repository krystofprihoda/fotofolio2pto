//
//  FeedRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public class FeedRepositoryImpl: FeedRepository {
    
    private let defaults: UserDefaultsProvider
    private let network: NetworkProvider
    
    init(defaults: UserDefaultsProvider, network: NetworkProvider) {
        self.defaults = defaults
        self.network = network
    }
    
    public func getAll() async throws -> [Portfolio] {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let portfolios: [Portfolio] = try await network.fetch(endpoint: .portfolio, method: .GET, body: nil, headers: headers, queryParams: nil)
        return portfolios
    }
    
    public func getAll(sorted: SortByEnum) async throws -> [Portfolio] {
        return try await getAll()
    }
    
    public func addToFlagged(portfolioId: String) throws {
        var flagged = getFlaggedIds()
        guard !flagged.contains(where: { $0 == portfolioId }) else { return }
        flagged.append(portfolioId)
        defaults.update(.flagged, value: flagged)
    }
    
    public func removeFromFlagged(portfolioId: String) throws {
        var flagged = getFlaggedIds()
        flagged.removeAll(where: { $0 == portfolioId })
        defaults.update(.flagged, value: flagged)
    }
    
    public func getFlagged() async throws -> [Portfolio] {
        return []
    }
        
    public func getFlaggedIds() -> [String] {
        return defaults.read(.flagged) ?? []
    }
    
    public func removeAllFlagged() throws {
        defaults.delete(.flagged)
    }
    
    public func getFilteredPortfolios(filter: [String]) async throws -> [Portfolio] {
        return []
    }
    
    public func getUserPortfolios(for username: String) async throws -> [Portfolio] {
        return []
    }
    
    public func createPortfolio(username: String, name: String, photos: [IImage], description: String, category: [String]) async throws {
    }
    
    public func updatePortfolio(id: String, name: String, photos: [IImage], description: String, category: [String]) async throws {
    }
}
