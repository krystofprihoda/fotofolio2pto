//
//  ReadChatsUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.04.2025.
//

import Foundation

public protocol ReadChatsUseCase {
    func execute() async throws -> [Chat]
}

public struct ReadChatsUseCaseImpl: ReadChatsUseCase {
    
    private let messageRepository: MessageRepository
    
    init(
        messageRepository: MessageRepository
    ) {
        self.messageRepository = messageRepository
    }
    
    public func execute() async throws -> [Chat] {
        return try await messageRepository.readUserChats()
    }
}
