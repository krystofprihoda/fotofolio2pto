//
//  Message.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import Foundation

public struct Message: Identifiable, Equatable {
    public let id: String
    public let chatId: String
    public var from: String
    public var to: String
    public var body: String
    public let timestamp: Date
}

extension Message: Codable {
    enum CodingKeys: String, CodingKey {
        case id, chatId, from, to, body, timestamp
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        id = try container.decode(String.self, forKey: .id)
        chatId = try container.decode(String.self, forKey: .chatId)
        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String.self, forKey: .to)
        body = try container.decode(String.self, forKey: .body)
        
        let timestampDouble = try container.decode(Double.self, forKey: .timestamp)
        timestamp = Date(timeIntervalSince1970: timestampDouble)
        }
        
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(chatId, forKey: .chatId)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(body, forKey: .body)
        try container.encode(timestamp.timeIntervalSince1970, forKey: .timestamp)
    }
}
