//
//  PortfolioRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation
import UIKit

public protocol PortfolioRepository {
    func createPortfolio(creatorId: String, name: String, photos: [IImage], price: Price, description: String, category: [String]) async throws
    func addToFlagged(portfolioId: String)
    func readAll(categories: [String]?, sortBy: SortByEnum?) async throws -> [Portfolio]
    func readFlagged() async throws -> [Portfolio]
    func readFlaggedIds() -> [String]
    func readImageFromURL(url: String) async throws -> UIImage
    func updatePortfolio(id: String, name: String, photos: [String], price: Price, description: String, category: [String]) async throws -> Portfolio
    func removeFromFlagged(portfolioId: String)
    func removeAllFlagged()
    func removePortfolio(id: String) async throws
}
