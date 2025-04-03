//
//  CreateNewChatWithMessageUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol CreateNewChatWithMessageUseCase {
    func execute(receiverId: String, message: String) async throws -> Chat
}

public struct CreateNewChatWithMessageUseCaseImpl: CreateNewChatWithMessageUseCase {
    
    private let messageRepository: MessageRepository
    
    init(
        messageRepository: MessageRepository
    ) {
        self.messageRepository = messageRepository
    }
    
    public func execute(receiverId: String, message: String) async throws -> Chat {
        return try await messageRepository.createNewChatWithMessage(receiverId: receiverId, message: message)
    }
}
