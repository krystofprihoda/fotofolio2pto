//
//  Portfolio.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation
import SwiftUI

public struct Portfolio: Identifiable, Equatable {
    public let id: String
    public let creatorId: String
    public let authorUsername: String
    public let name: String
    public let photos: [IImage]
    public let price: Price
    public let description: String
    public let category: [String]
    public let timestamp: Date
    
    public init(
        id: String,
        creatorId: String,
        authorUsername: String,
        name: String,
        photos: [IImage],
        price: Price,
        description: String,
        category: [String],
        timestamp: Date
    ) {
        self.id = id
        self.creatorId = creatorId
        self.authorUsername = authorUsername
        self.name = name
        self.photos = photos
        self.price = price
        self.description = description
        self.category = category
        self.timestamp = timestamp
    }
    
    public static func == (lhs: Portfolio, rhs: Portfolio) -> Bool {
        lhs.id == rhs.id
    }
}

extension Portfolio: Codable {
    enum CodingKeys: String, CodingKey {
        case id, creatorId, authorUsername, name, photos, price, description, category, timestamp
    }
    
    public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            creatorId = try container.decode(String.self, forKey: .creatorId)
            name = try container.decode(String.self, forKey: .name)
            authorUsername = try container.decode(String.self, forKey: .authorUsername)
            
            // Special handling for photos
            let photoURLs = try container.decode([String].self, forKey: .photos)
            photos = photoURLs.compactMap { urlString in
                return IImage(src: .remote(urlString))
            }
            
            let priceDecoded = try container.decode(Int.self, forKey: .price)
            if priceDecoded == 0 {
                price = .priceOnRequest
            } else {
                price = .fixed(priceDecoded)
            }
            description = try container.decode(String.self, forKey: .description)
            category = try container.decode([String].self, forKey: .category)
        
            let timeInterval = try container.decode(Double.self, forKey: .timestamp)
            timestamp = Date(timeIntervalSince1970: timeInterval)
        }
        
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creatorId, forKey: .creatorId)
        try container.encode(authorUsername, forKey: .authorUsername)
        try container.encode(name, forKey: .name)
        
        // Convert photos to URL strings
        let photoURLs = photos.compactMap { image in
            switch image.src {
            case .remote(let url):
                return url
            case .local:
                return nil
            }
        }
        try container.encode(photoURLs, forKey: .photos)
        
        if case .priceOnRequest = price {
            try container.encode(0, forKey: .price)
        } else if case .fixed(let fixedPrice) = price {
            try container.encode(fixedPrice, forKey: .price)
        }
        
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        
        try container.encode(timestamp.timeIntervalSince1970, forKey: .timestamp)
    }
}

public enum Price: Equatable, Hashable {
    case priceOnRequest
    case fixed(Int)
}
