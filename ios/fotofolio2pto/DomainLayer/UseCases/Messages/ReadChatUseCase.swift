//
//  ReadChatUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol ReadChatUseCase {
    func execute(receiverId: String) async throws -> Chat
}

public struct ReadChatUseCaseImpl: ReadChatUseCase {
    
    private let messageRepository: MessageRepository
    
    init(
        messageRepository: MessageRepository
    ) {
        self.messageRepository = messageRepository
    }
    
    public func execute(receiverId: String) async throws -> Chat {
        return try await messageRepository.readChat(receiverId: receiverId)
    }
}
