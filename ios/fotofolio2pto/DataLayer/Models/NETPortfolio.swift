//
//  NETPortfolio.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.05.2025.
//

import Foundation
import UIKit

public struct NETPortfolio: Codable {
    let id: String
    let creatorId: String
    let authorUsername: String
    let name: String
    let photos: [String] // URLs as strings
    let price: Int       // 0 for priceOnRequest, actual value for fixed
    let description: String
    let category: [String]
    let timestamp: Double // timeIntervalSince1970
    
    enum CodingKeys: String, CodingKey {
        case id, creatorId, authorUsername, name, photos, price, description, category, timestamp
    }
    
    init(id: String, creatorId: String, authorUsername: String, name: String, photos: [String], price: Int, description: String, category: [String], timestamp: Double) {
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        creatorId = try container.decode(String.self, forKey: .creatorId)
        name = try container.decode(String.self, forKey: .name)
        authorUsername = try container.decode(String.self, forKey: .authorUsername)
        photos = try container.decode([String].self, forKey: .photos)
        price = try container.decode(Int.self, forKey: .price)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode([String].self, forKey: .category)
        timestamp = try container.decode(Double.self, forKey: .timestamp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creatorId, forKey: .creatorId)
        try container.encode(authorUsername, forKey: .authorUsername)
        try container.encode(name, forKey: .name)
        try container.encode(photos, forKey: .photos)
        try container.encode(price, forKey: .price)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

// Conversion from NetworkModel to DomainModel
extension NETPortfolio: DomainRepresentable {
    public typealias DomainModel = Portfolio
    
    public var domainModel: DomainModel {
        get throws {
            let domainPhotos = photos.map { IImage(src: .remote($0)) }
            
            let domainPrice: Price = price == 0 ? .priceOnRequest : .fixed(price)
            
            return Portfolio(
                id: id,
                creatorId: creatorId,
                authorUsername: authorUsername,
                name: name,
                photos: domainPhotos,
                price: domainPrice,
                description: description,
                category: category,
                timestamp: Date(timeIntervalSince1970: timestamp)
            )
        }
    }
}

// Conversion from DomainModel to NetworkModel
extension Portfolio: NetworkRepresentable {
    public typealias NetworkModel = NETPortfolio
    
    public var networkModel: NetworkModel {
        let netPhotos = photos.compactMap { image in
            switch image.src {
            case .remote(let url):
                return url
            case .local:
                return nil
            }
        }
        
        let netPrice: Int
        switch price {
        case .priceOnRequest:
            netPrice = 0
        case .fixed(let value):
            netPrice = value
        }
        
        return NETPortfolio(
            id: id,
            creatorId: creatorId,
            authorUsername: authorUsername,
            name: name,
            photos: netPhotos,
            price: netPrice,
            description: description,
            category: category,
            timestamp: timestamp.timeIntervalSince1970
        )
    }
}
