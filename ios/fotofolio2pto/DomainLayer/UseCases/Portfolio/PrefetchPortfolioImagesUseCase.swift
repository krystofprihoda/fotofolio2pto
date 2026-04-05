//
//  PrefetchPortfolioImagesUseCase.swift
//  fotofolio2pto
//
//  Created by k r y š t o f on 05.04.2026.
//

import Foundation

public protocol PrefetchPortfolioImagesUseCase {
    func execute(portfolios: [Portfolio])
}

public struct PrefetchPortfolioImagesUseCaseImpl: PrefetchPortfolioImagesUseCase {

    private let portfolioRepository: PortfolioRepository

    init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }

    public func execute(portfolios: [Portfolio]) {
        let urls: [URL] = portfolios.flatMap { portfolio in
            portfolio.photos.compactMap { image in
                guard case .remote(let urlStr) = image.src else { return nil }
                let trimmed = urlStr.trimmingCharacters(in: .whitespacesAndNewlines)
                return URL(string: trimmed)
                    ?? URL(string: trimmed.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")
            }
        }
        portfolioRepository.prefetchImages(urls: urls)
    }
}
