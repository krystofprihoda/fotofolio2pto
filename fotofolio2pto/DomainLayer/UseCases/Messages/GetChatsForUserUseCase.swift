//
//  GetChatsForUserUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol GetChatsForUserUseCase {
    func execute(user: String) async throws -> [Chat]
}

public struct GetChatsForUserUseCaseImpl: GetChatsForUserUseCase {
    
    private let messageRepository: MessageRepository
    
    init(messageRepository: MessageRepository) {
        self.messageRepository = messageRepository
    }
    
    public func execute(user: String) async throws -> [Chat] {
        try await messageRepository.getChatsForUser(user)
    }
}
