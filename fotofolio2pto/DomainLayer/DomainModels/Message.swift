//
//  Message.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    var from: String
    var to: String
    var body: String
    let timestamp: Date
}

extension Message {
    static let sampleData1: [Message] = [dummy1, dummy2]
    static let sampleData2: [Message] = [dummy3]
    
    static var dummy1: Message {
        Message(from: "ad.fotograf", to: "vojtafoti", body: "Ahoj, super fotky...", timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
    }
    
    static var dummy2: Message {
        Message(from: "vojtafoti", to: "ad.fotograf", body: "Tyjo, diky moc!", timestamp: .now)
    }
    
    static var dummy3: Message {
        Message(from: "karel__foti", to: "vojtafoti", body: "cau", timestamp: .now)
    }
}
