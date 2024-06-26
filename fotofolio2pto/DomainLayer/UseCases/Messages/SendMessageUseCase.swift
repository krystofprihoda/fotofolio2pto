//
//  SendMessageUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol SendMessageUseCase {
    func execute(text: String, chat: Chat, sender: String) async throws
}

public struct SendMessageUseCaseImpl: SendMessageUseCase {
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    public func execute(text: String, chat: Chat, sender: String) async throws {
        try await messageRepository.sendMessage(text, chat: chat, sender: sender)
    }
}
