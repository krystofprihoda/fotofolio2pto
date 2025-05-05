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

public enum Price: Equatable, Hashable {
    case priceOnRequest
    case fixed(Int)
}
