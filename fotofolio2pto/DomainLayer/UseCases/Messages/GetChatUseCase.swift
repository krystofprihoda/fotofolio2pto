//
//  GetChatUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol GetChatUseCase {
    func execute(sender: String, receiver: String) async throws -> Chat
}

public struct GetChatUseCaseImpl: GetChatUseCase {
    
    private let messageRepository: MessageRepository
    private let userRepository: UserRepository
    
    init(
        messageRepository: MessageRepository,
        userRepository: UserRepository
    ) {
        self.messageRepository = messageRepository
        self.userRepository = userRepository
    }
    
    public func execute(sender: String, receiver: String) async throws -> Chat {
        guard let senderUser = try await userRepository.getUserByUsername(sender) else { throw ObjectError.nonExistent }
        guard let receiverUser = try await userRepository.getUserByUsername(receiver) else { throw ObjectError.nonExistent }
        
        return try await messageRepository.getOrCreateChatFor(sender: senderUser, receiver: receiverUser)
    }
}
