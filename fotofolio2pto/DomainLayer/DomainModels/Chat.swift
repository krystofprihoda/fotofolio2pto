//
//  Chat.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import Foundation

struct Chat: Identifiable {
    let id = UUID()
    let sender: User
    let receiver: User
    var messages: [Message]
}

extension Chat {
    static let sampleData: [Chat] = [dummy1, dummy2]
    
    static var dummy1: Chat {
        Chat(sender: User.dummy1, receiver: User.dummy2, messages: Message.sampleData1)
    }
    
    static var dummy2: Chat {
        Chat(sender: User.dummy1, receiver: User.dummy3, messages: Message.sampleData2)
    }
}
