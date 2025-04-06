//
//  MessageRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public class MessageRepositoryImpl: MessageRepository {
    
    private let defaults: UserDefaultsProvider
    private let network: NetworkProvider
    
    init(defaults: UserDefaultsProvider, network: NetworkProvider) {
        self.defaults = defaults
        self.network = network
    }
    
    public func createNewChatWithMessage(receiverId: String, message: String) async throws -> Chat {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var body: [String:String] = [
            "message": message
        ]
        
        let chat: Chat = try await network.fetch(
            endpoint: .chat,
            method: .POST,
            body: body,
            headers: headers,
            queryParams: nil
        )
        return chat
    }
    
    public func readUserChats() async throws -> [Chat] {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let chats: [Chat] = try await network.fetch(
            endpoint: .chat,
            method: .GET,
            body: nil,
            headers: headers,
            queryParams: nil
        )
        return chats
    }
    
    public func readChat(receiverId: String) async throws -> Chat {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var queryParams: [String: String] = [
            "receiverId": receiverId
        ]
        
        let chat: Chat = try await network.fetch(
            endpoint: .chat,
            method: .GET,
            body: nil,
            headers: headers,
            queryParams: queryParams
        )
        return chat
    }
    
    public func readMessages(chatId: String) async throws -> [Message] {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let messages: [Message] = try await network.fetch(
            endpoint: .messageByChatId(chatId),
            method: .GET,
            body: nil,
            headers: headers,
            queryParams: nil
        )
        return messages
    }
    
    public func sendMessage(chatId: String, message: String) async throws -> Chat {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var body: [String:String] = [
            "message": message
        ]
        
        let chat: Chat = try await network.fetch(
            endpoint: .messageByChatId(chatId),
            method: .POST,
            body: body,
            headers: headers,
            queryParams: nil
        )
        return chat
    }
    
    public func sendMessage(receiverId: String, message: String) async throws -> Chat {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var body: [String:String] = [
            "message": message,
            "receiverId": receiverId
        ]
        
        let chat: Chat = try await network.fetch(
            endpoint: .chat,
            method: .POST,
            body: body,
            headers: headers,
            queryParams: nil
        )
        return chat
    }
}
