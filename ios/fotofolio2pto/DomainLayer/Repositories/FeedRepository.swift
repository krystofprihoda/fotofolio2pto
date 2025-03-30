//
//  FeedRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol FeedRepository {
    func readAll(categories: [String]?, sortBy: SortByEnum?) async throws -> [Portfolio]
    func addToFlagged(portfolioId: String) throws
    func removeFromFlagged(portfolioId: String) throws
    func readFlagged() async throws -> [Portfolio]
    func readFlaggedIds() -> [String]
    func removeAllFlagged() throws
    // func createPortfolio(username: String, name: String, photos: [IImage], description: String, category: [String]) async throws
    // func updatePortfolio(id: String, name: String, photos: [IImage], description: String, category: [String]) async throws
}
