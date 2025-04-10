//
//  ReadRemoteImageUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 05.04.2025.
//

import Foundation
import UIKit

public protocol ReadRemoteImageUseCase {
    func execute(url: String) async throws -> UIImage
}

public class ReadRemoteImageUseCaseImpl: ReadRemoteImageUseCase {
    
    private let portfolioRepository: PortfolioRepository
    
    public init(portfolioRepository: PortfolioRepository) {
        self.portfolioRepository = portfolioRepository
    }
    
    public func execute(url: String) async throws -> UIImage {
        return try await portfolioRepository.readImageFromURL(url: url)
    }
}
