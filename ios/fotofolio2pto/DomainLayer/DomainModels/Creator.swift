//
//  Creator.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation

public struct Creator: Codable {
    public let id: String
    public let profileText: String
    public let yearsOfExperience: Int
    public let portfolioIds: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "creatorId"
        case profileText, yearsOfExperience, portfolioIds
    }
}

extension Creator {
    static var dummy1: Creator {
        Creator(id: "1", profileText: "Specializuji se na svatební fotografii a portréty, ale poradím si i s reality, produktovkama a vlastně vším...", yearsOfExperience: 10, portfolioIds: [])
    }
    
    static var dummy2: Creator {
        Creator(id: "2", profileText: "eat - sleep - create | nafotím cokoliv od svateb až po reality | dji, sony", yearsOfExperience: 7, portfolioIds: [])
    }
    
    static var dummy3: Creator {
        Creator(id: "3", profileText: "cau tady karel, fotim skvele koukni na portfolia.", yearsOfExperience: 1, portfolioIds: [])
    }
    
    static var dummy4: Creator {
        Creator(id: "4", profileText: "Řikaj mi Míra a nafotim Ti cokoliv, na co si jen vzpomeneš...", yearsOfExperience: 1, portfolioIds: [])
    }
    
    static var dummy5: Creator {
        Creator(id: "5", profileText: "Jmenuju se Milan a věnuji se fotografování portrétů. Sony a7r iv.", yearsOfExperience: 1, portfolioIds: [])
    }
}
