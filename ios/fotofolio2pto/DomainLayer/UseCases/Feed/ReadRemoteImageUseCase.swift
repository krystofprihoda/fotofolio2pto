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
    
    private let feedRepository: FeedRepository
    
    public init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    public func execute(url: String) async throws -> UIImage {
        return try await feedRepository.readImageFromURL(url: url)
    }
}
