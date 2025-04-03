//
//  ReadMessagesFromChatUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.04.2025.
//

import Foundation

public protocol ReadMessagesFromChatUseCase {
    func execute(chatId: String) async throws -> [Message]
}

public struct ReadMessagesFromChatUseCaseImpl: ReadMessagesFromChatUseCase {
    
    private let messageRepository: MessageRepository
    
    init(
        messageRepository: MessageRepository
    ) {
        self.messageRepository = messageRepository
    }
    
    public func execute(chatId: String) async throws -> [Message] {
        return try await messageRepository.readMessages(chatId: chatId)
    }
}
