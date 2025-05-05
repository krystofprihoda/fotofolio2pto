//
//  Message.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import Foundation

public struct Message: Identifiable, Equatable {
    public let id: String
    public let chatId: String
    public var from: String
    public var to: String
    public var body: String
    public let timestamp: Date
}
