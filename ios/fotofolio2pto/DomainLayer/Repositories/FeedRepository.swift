//
//  FeedRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation
import UIKit

public protocol FeedRepository {
    func createPortfolio(creatorId: String, name: String, photos: [IImage], description: String, category: [String]) async throws
    func addToFlagged(portfolioId: String) throws
    func readAll(categories: [String]?, sortBy: SortByEnum?) async throws -> [Portfolio]
    func readFlagged() async throws -> [Portfolio]
    func readFlaggedIds() -> [String]
    func readImageFromURL(url: String) async throws -> UIImage
    func updatePortfolio(id: String, name: String, photos: [String], description: String, category: [String]) async throws -> Portfolio
    func removeFromFlagged(portfolioId: String) throws
    func removeAllFlagged() throws
    func removePortfolio(id: String) async throws
}
