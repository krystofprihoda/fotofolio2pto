//
//  MessageRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol MessageRepository {
    func getChatsForUser(_ user: String) async throws -> [Chat]
    func createNewChat(sender: User, receiver: User) async throws -> Chat
    func sendMessage(_ text: String, chat: Chat, sender: String) async throws
    func getLatestChatMessages(for chat: Chat) async throws -> [Message]
    func getOrCreateChatFor(sender: User, receiver: User) async throws -> Chat
}
