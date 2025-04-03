//
//  Chat.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import Foundation

public struct Chat: Identifiable, Equatable {
    public let id: String
    public let chatOwnerIds: [String]
    public let messageIds: [String]
    public let lastUpdated: Date
    public let lastMessage: String
    public let lastSenderId: String
    
    public init(
        id: String,
        chatOwnerIds: [String],
        messageIds: [String],
        lastUpdated: Date,
        lastMessage: String,
        lastSenderId: String
    ) {
        self.id = id
        self.chatOwnerIds = chatOwnerIds
        self.messageIds = messageIds
        self.lastUpdated = lastUpdated
        self.lastMessage = lastMessage
        self.lastSenderId = lastSenderId
    }
    
    public static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func getReceiverId(senderId: String) -> String? {
        return senderId == chatOwnerIds.first ? chatOwnerIds.last : chatOwnerIds.first
    }
}

extension Chat: Codable {
    enum CodingKeys: String, CodingKey {
        case id, chatOwnerIds, messageIds, lastUpdated, lastMessage, lastSenderId
    }
    
    public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        
            id = try container.decode(String.self, forKey: .id)
            chatOwnerIds = try container.decode([String].self, forKey: .chatOwnerIds)
            messageIds = try container.decode([String].self, forKey: .messageIds)
            lastMessage = try container.decode(String.self, forKey: .lastMessage)
            lastSenderId = try container.decode(String.self, forKey: .lastSenderId)
        
            let lastUpdatedInt = try container.decode(Int.self, forKey: .lastUpdated)
            lastUpdated = Date(timeIntervalSince1970: Double(lastUpdatedInt))
        }
        
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(chatOwnerIds, forKey: .chatOwnerIds)
        try container.encode(messageIds, forKey: .messageIds)
        try container.encode(lastUpdated.timeIntervalSince1970, forKey: .lastUpdated)
        try container.encode(lastMessage, forKey: .lastMessage)
        try container.encode(lastSenderId, forKey: .lastSenderId)
    }
}

extension Chat {
    public static var empty: Chat {
        Chat(id: "", chatOwnerIds: [], messageIds: [], lastUpdated: .now, lastMessage: "", lastSenderId: "")
    }
}
