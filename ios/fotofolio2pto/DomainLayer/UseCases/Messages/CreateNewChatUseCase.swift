//
//  CreateNewChatUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol CreateNewChatUseCase {
    func execute(sender: String, receiver: User) async throws -> Chat
}

public struct CreateNewChatUseCaseImpl: CreateNewChatUseCase {
    
    private let messageRepository: MessageRepository
    private let userRepository: UserRepository
    
    init(
        messageRepository: MessageRepository,
        userRepository: UserRepository
    ) {
        self.messageRepository = messageRepository
        self.userRepository = userRepository
    }
    
    public func execute(sender: String, receiver: User) async throws -> Chat {
        guard let user = try await userRepository.getUserByUsername(sender) else { throw ObjectError.nonExistent }
        return try await messageRepository.createNewChat(sender: user, receiver: receiver)
    }
}
