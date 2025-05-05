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
    public let readByIds: [String]
    
    public init(
        id: String,
        chatOwnerIds: [String],
        messageIds: [String],
        lastUpdated: Date,
        lastMessage: String,
        lastSenderId: String,
        readByIds: [String]
    ) {
        self.id = id
        self.chatOwnerIds = chatOwnerIds
        self.messageIds = messageIds
        self.lastUpdated = lastUpdated
        self.lastMessage = lastMessage
        self.lastSenderId = lastSenderId
        self.readByIds = readByIds
    }
    
    public static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func getReceiverId(senderId: String) -> String? {
        return senderId == chatOwnerIds.first ? chatOwnerIds.last : chatOwnerIds.first
    }
}

extension Chat {
    public static var empty: Chat {
        Chat(id: "", chatOwnerIds: [], messageIds: [], lastUpdated: .now, lastMessage: "", lastSenderId: "", readByIds: [])
    }
}
