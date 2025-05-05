//
//  NETMessage.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.05.2025.
//

import Foundation

public struct NETMessage: Codable {
    let id: String
    let chatId: String
    let from: String
    let to: String
    let body: String
    let timestamp: Double
    
    enum CodingKeys: String, CodingKey {
        case id, chatId, from, to, body, timestamp
    }
    
    init(id: String, chatId: String, from: String, to: String, body: String, timestamp: Double) {
        self.id = id
        self.chatId = chatId
        self.from = from
        self.to = to
        self.body = body
        self.timestamp = timestamp
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        id = try container.decode(String.self, forKey: .id)
        chatId = try container.decode(String.self, forKey: .chatId)
        from = try container.decode(String.self, forKey: .from)
        to = try container.decode(String.self, forKey: .to)
        body = try container.decode(String.self, forKey: .body)
        
        timestamp = try container.decode(Double.self, forKey: .timestamp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(chatId, forKey: .chatId)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(body, forKey: .body)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

// Conversion from NetworkModel to DomainModel
extension NETMessage: DomainRepresentable {
    public typealias DomainModel = Message
    
    public var domainModel: DomainModel {
        get throws {
            return Message(
                id: id,
                chatId: chatId,
                from: from,
                to: to,
                body: body,
                timestamp: Date(timeIntervalSince1970: timestamp)
            )
        }
    }
}

// Conversion from DomainModel to NetworkModel
extension Message: NetworkRepresentable {
    public typealias NetworkModel = NETMessage
    
    public var networkModel: NetworkModel {
        return NETMessage(
            id: id,
            chatId: chatId,
            from: from,
            to: to,
            body: body,
            timestamp: timestamp.timeIntervalSince1970
        )
    }
}
