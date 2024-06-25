//
//  FeedRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol FeedRepository {
    func getAll() async throws -> [Portfolio]
    func getAll(sorted: SortByEnum) async throws -> [Portfolio]
    func getById(_ id: Int) async throws -> Portfolio
    func addToFlagged(portfolioId: Int) throws
    func removeFromFlagged(portfolioId: Int) throws
    func getFlagged() async throws -> [Portfolio]
    func getFlaggedIds() -> [Int]
    func removeAllFlagged() throws
    func getFilteredPortfolios(filter: [String]) async throws -> [Portfolio]
}
