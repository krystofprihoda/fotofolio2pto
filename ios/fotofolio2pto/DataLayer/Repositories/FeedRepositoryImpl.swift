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
    
    public func readAll(categories: [String]? = nil, sortBy: SortByEnum? = nil) async throws -> [Portfolio] {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        var queryParams: [String: String] = [:]
        
        if let categories = categories, !categories.isEmpty {
            for category in categories {
                queryParams["category"] = category
            }
        }
        
        if let sortBy = sortBy {
            switch sortBy {
            case .date:
                queryParams["sortBy"] = "timestamp"
            case .rating:
                queryParams["sortBy"] = "rating"
            }
        }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let portfolios: [Portfolio] = try await network.fetch(
            endpoint: .portfolio,
            method: .GET,
            body: nil,
            headers: headers,
            queryParams: queryParams
        )
        return portfolios
    }
    
    public func addToFlagged(portfolioId: String) throws {
        var flagged = readFlaggedIds()
        guard !flagged.contains(where: { $0 == portfolioId }) else { return }
        flagged.append(portfolioId)
        defaults.update(.flagged, value: flagged)
    }
    
    public func removeFromFlagged(portfolioId: String) throws {
        var flagged = readFlaggedIds()
        flagged.removeAll(where: { $0 == portfolioId })
        defaults.update(.flagged, value: flagged)
    }
    
    public func readFlagged() async throws -> [Portfolio] {
        return []
    }
        
    public func readFlaggedIds() -> [String] {
        return defaults.read(.flagged) ?? []
    }
    
    public func removeAllFlagged() throws {
        defaults.delete(.flagged)
    }
}
