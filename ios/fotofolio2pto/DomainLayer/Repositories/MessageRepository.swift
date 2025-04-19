//
//  MessageRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol MessageRepository {
    func createNewChatWithMessage(receiverId: String, message: String) async throws -> Chat
    func sendMessage(chatId: String, message: String) async throws -> Chat
    func sendMessage(receiverId: String, message: String) async throws -> Chat
    func readChat(receiverId: String) async throws -> Chat
    func readUserChats() async throws -> [Chat]
    func readMessages(chatId: String) async throws -> [Message]
    func updateChatRead(chatId: String) async throws
}
