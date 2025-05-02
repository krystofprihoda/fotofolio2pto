//
//  NETChat.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.05.2025.
//

import Foundation

struct NETChat: Codable {
    let id: String
    let chatOwnerIds: [String]
    let messageIds: [String]
    let lastUpdated: Int
    let lastMessage: String
    let lastSenderId: String
    let readByIds: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, chatOwnerIds, messageIds, lastUpdated, lastMessage, lastSenderId, readByIds
    }
    
    init(id: String, chatOwnerIds: [String], messageIds: [String], lastUpdated: Int, lastMessage: String, lastSenderId: String, readByIds: [String]) {
        self.id = id
        self.chatOwnerIds = chatOwnerIds
        self.messageIds = messageIds
        self.lastUpdated = lastUpdated
        self.lastMessage = lastMessage
        self.lastSenderId = lastSenderId
        self.readByIds = readByIds
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        chatOwnerIds = try container.decode([String].self, forKey: .chatOwnerIds)
        messageIds = try container.decode([String].self, forKey: .messageIds)
        lastMessage = try container.decode(String.self, forKey: .lastMessage)
        lastSenderId = try container.decode(String.self, forKey: .lastSenderId)
        
        lastUpdated = try container.decode(Int.self, forKey: .lastUpdated)
        readByIds = try container.decode([String].self, forKey: .readByIds)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(chatOwnerIds, forKey: .chatOwnerIds)
        try container.encode(messageIds, forKey: .messageIds)
        try container.encode(lastUpdated, forKey: .lastUpdated)
        try container.encode(lastMessage, forKey: .lastMessage)
        try container.encode(lastSenderId, forKey: .lastSenderId)
        try container.encode(readByIds, forKey: .readByIds)
    }
}

// Conversion from NetworkModel to DomainModel
extension NETChat: DomainRepresentable {
    typealias DomainModel = Chat
    
    var domainModel: DomainModel {
        get throws {
            return Chat(
                id: id,
                chatOwnerIds: chatOwnerIds,
                messageIds: messageIds,
                lastUpdated: Date(timeIntervalSince1970: Double(lastUpdated)),
                lastMessage: lastMessage,
                lastSenderId: lastSenderId,
                readByIds: readByIds
            )
        }
    }
}

// Conversion from DomainModel to NetworkModel
extension Chat: NetworkRepresentable {
    typealias NetworkModel = NETChat
    
    var networkModel: NetworkModel {
        return NETChat(
            id: id,
            chatOwnerIds: chatOwnerIds,
            messageIds: messageIds,
            lastUpdated: Int(lastUpdated.timeIntervalSince1970),
            lastMessage: lastMessage,
            lastSenderId: lastSenderId,
            readByIds: readByIds
        )
    }
}
