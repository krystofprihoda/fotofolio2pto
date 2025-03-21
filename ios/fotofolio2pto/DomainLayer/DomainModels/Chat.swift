//
//  Chat.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import Foundation

public struct Chat: Identifiable, Equatable {
    public let id: Int
    public var chatOwners: [User]
    public var messages: [Message] = []
    
    public static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
    }
    
    public func getReceiver(sender: String) -> String? {
        return sender == chatOwners.first?.username ? chatOwners.last?.username : chatOwners.first?.username
    }
}

extension Chat {
    static let sampleData: [Chat] = [dummy1, dummy2]
    
    static var dummy1: Chat {
        Chat(id: 0, chatOwners: [User.dummy1, User.dummy2], messages: Message.sampleData1)
    }
    
    static var dummy2: Chat {
        Chat(id: 1, chatOwners: [User.dummy1, User.dummy3], messages: Message.sampleData2)
    }
}
