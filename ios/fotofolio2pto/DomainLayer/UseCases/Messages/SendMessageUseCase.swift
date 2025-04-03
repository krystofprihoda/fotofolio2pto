//
//  SendMessageUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol SendMessageUseCase {
    func execute(chatId: String, message: String) async throws -> Chat
    func execute(receiverId: String, message: String) async throws -> Chat
}

public struct SendMessageUseCaseImpl: SendMessageUseCase {
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    public func execute(chatId: String, message: String) async throws -> Chat {
        try await messageRepository.sendMessage(chatId: chatId, message: message)
    }
    
    public func execute(receiverId: String, message: String) async throws -> Chat {
        try await messageRepository.sendMessage(receiverId: receiverId, message: message)
    }
}
