//
//  UpdateChatReadUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 19.04.2025.
//

import Foundation

public protocol UpdateChatReadUseCase {
    func execute(chatId: String) async throws
}

public struct UpdateChatReadUseCaseImpl: UpdateChatReadUseCase {
    
    private let messageRepository: MessageRepository
    
    init(
        messageRepository: MessageRepository
    ) {
        self.messageRepository = messageRepository
    }
    
    public func execute(chatId: String) async throws {
        return try await messageRepository.updateChatRead(chatId: chatId)
    }
}
