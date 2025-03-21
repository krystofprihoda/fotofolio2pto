//
//  MessageRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public class MessageRepositoryImpl: MessageRepository {
    
    private static var chats: [Chat] = Chat.sampleData
    
    public func getChatsForUser(_ user: String) async throws -> [Chat] {
        try await Task.sleep(for: .seconds(0.5))
        return MessageRepositoryImpl.chats.filter({ chat in
            chat.chatOwners.contains(where: { owner in
                owner.username == user
            })
        })
    }
    
    public func createNewChat(sender: User, receiver: User) async throws -> Chat {
        try await Task.sleep(for: .seconds(0.3))
        let latestId = MessageRepositoryImpl.chats.last?.id ?? 0
        let chat = Chat(id: latestId + 1, chatOwners: [sender, receiver])
        MessageRepositoryImpl.chats.append(chat)
        return chat
    }
    
    public func sendMessage(_ text: String, chat: Chat, sender: String) async throws {
        try await Task.sleep(for: .seconds(0.2))
        guard let idx = MessageRepositoryImpl.chats.firstIndex(where: { $0 == chat }) else {
            throw ObjectError.nonExistent
        }
        guard let receiver = chat.getReceiver(sender: sender) else { throw ObjectError.nonExistent }
        let message = Message(from: sender, to: receiver, body: text, timestamp: .now)
        MessageRepositoryImpl.chats[idx].messages.append(message)
    }
    
    public func getLatestChatMessages(for chat: Chat) async throws -> [Message] {
        try await Task.sleep(for: .seconds(0.3))
        guard let updatedChat = MessageRepositoryImpl.chats.first(where: { $0 == chat }) else { throw ObjectError.nonExistent }
        return updatedChat.messages
    }
    
    public func getOrCreateChatFor(sender: User, receiver: User) async throws -> Chat {
        try await Task.sleep(for: .seconds(0.3))
        guard let existingChat = MessageRepositoryImpl.chats.first(where: {
            $0.chatOwners.contains(where: { $0 == sender }) && $0.chatOwners.contains(where: { $0 == receiver })
        }) else {
            return try await createNewChat(sender: sender, receiver: receiver)
        }
        
        return existingChat
    }
}
