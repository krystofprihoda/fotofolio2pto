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
    func getById(_ id: UUID) async throws -> Portfolio
    func addToFlagged(portfolioId: UUID) throws
    func removeFromFlagged(portfolioId: UUID) throws
    func getFlagged() async throws -> [Portfolio]
    func getFlaggedIds() -> [UUID]
    func removeAllFlagged() throws
}
