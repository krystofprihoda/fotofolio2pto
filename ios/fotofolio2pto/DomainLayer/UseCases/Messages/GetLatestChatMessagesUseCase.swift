//
//  GetLatestChatMessagesUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol GetLatestChatMessagesUseCase {
    func execute(for chat: Chat) async throws -> [Message]
}

public struct GetLatestChatMessagesUseCaseImpl: GetLatestChatMessagesUseCase {
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    public func execute(for chat: Chat) async throws -> [Message] {
        return try await messageRepository.getLatestChatMessages(for: chat)
    }
}
