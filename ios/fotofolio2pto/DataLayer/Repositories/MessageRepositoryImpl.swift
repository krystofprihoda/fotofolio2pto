//
//  MessageRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public class MessageRepositoryImpl: MessageRepository {
    
    private let encryptedStorage: EncryptedLocalStorageProvider
    private let network: NetworkProvider
    
    init(encryptedStorage: EncryptedLocalStorageProvider, network: NetworkProvider) {
        self.encryptedStorage = encryptedStorage
        self.network = network
    }
    
    public func createNewChatWithMessage(receiverId: String, message: String) async throws -> Chat {
        let body: [String:String] = [
            "message": message
        ]
        
        let netChat: NETChat = try await network.fetch(
            endpoint: .chat,
            method: .POST,
            body: body,
            headers: nil,
            queryParams: nil,
            auth: true
        )
        return try netChat.domainModel
    }
    
    public func readUserChats() async throws -> [Chat] {
        let netChats: [NETChat] = try await network.fetch(
            endpoint: .chat,
            method: .GET,
            body: nil,
            headers: nil,
            queryParams: nil,
            auth: true
        )
        return try netChats.map { try $0.domainModel }
    }
    
    public func readChat(receiverId: String) async throws -> Chat {
        let queryParams: [String: String] = [
            "receiverId": receiverId
        ]
        
        let netChat: NETChat = try await network.fetch(
            endpoint: .chat,
            method: .GET,
            body: nil,
            headers: nil,
            queryParams: queryParams,
            auth: true
        )
        return try netChat.domainModel
    }
    
    public func readMessages(chatId: String) async throws -> [Message] {
        let netMessages: [NETMessage] = try await network.fetch(
            endpoint: .messageByChatId(chatId),
            method: .GET,
            body: nil,
            headers: nil,
            queryParams: nil,
            auth: true
        )
        return try netMessages.map { try $0.domainModel }
    }
    
    public func sendMessage(chatId: String, message: String) async throws -> Chat {
        let body: [String:String] = [
            "message": message
        ]
        
        let netChat: NETChat = try await network.fetch(
            endpoint: .messageByChatId(chatId),
            method: .POST,
            body: body,
            headers: nil,
            queryParams: nil,
            auth: true
        )
        return try netChat.domainModel
    }
    
    public func sendMessage(receiverId: String, message: String) async throws -> Chat {
        let body: [String:String] = [
            "message": message,
            "receiverId": receiverId
        ]
        
        let netChat: NETChat = try await network.fetch(
            endpoint: .chat,
            method: .POST,
            body: body,
            headers: nil,
            queryParams: nil,
            auth: true
        )
        return try netChat.domainModel
    }
    
    public func updateChatRead(chatId: String) async throws {
        let _ = try await network.request(endpoint: .chatRead(chatId), method: .POST, body: nil, headers: nil, queryParams: nil, auth: true)
    }
}
