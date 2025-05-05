//
//  Creator.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation

public struct Creator: Codable {
    public let id: String
    public let userId: String
    public let description: String
    public let yearsOfExperience: Int
    public let portfolioIds: [String]
}

extension Creator {
    static var dummy1: Creator {
        Creator(id: "1", userId: "2", description: "Specializuji se na svatební fotografii a portréty, ale poradím si i s reality, produktovkama a vlastně vším...", yearsOfExperience: 10, portfolioIds: [])
    }
    
    static var dummy2: Creator {
        Creator(id: "2", userId: "2", description: "eat - sleep - create | nafotím cokoliv od svateb až po reality | dji, sony", yearsOfExperience: 7, portfolioIds: [])
    }
}
