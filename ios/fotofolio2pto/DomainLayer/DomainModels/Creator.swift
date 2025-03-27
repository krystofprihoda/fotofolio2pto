//
//  Creator.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation

public struct Creator: Codable {
    public let profileText: String
    public let yearsOfExperience: Int
}

extension Creator {
    static var dummy1: Creator {
        Creator(profileText: "Specializuji se na svatební fotografii a portréty, ale poradím si i s reality, produktovkama a vlastně vším...", yearsOfExperience: 10)
    }
    
    static var dummy2: Creator {
        Creator(profileText: "eat - sleep - create | nafotím cokoliv od svateb až po reality | dji, sony", yearsOfExperience: 7)
    }
    
    static var dummy3: Creator {
        Creator(profileText: "cau tady karel, fotim skvele koukni na portfolia.", yearsOfExperience: 1)
    }
    
    static var dummy4: Creator {
        Creator(profileText: "Řikaj mi Míra a nafotim Ti cokoliv, na co si jen vzpomeneš...", yearsOfExperience: 1)
    }
    
    static var dummy5: Creator {
        Creator(profileText: "Jmenuju se Milan a věnuji se fotografování portrétů. Sony a7r iv.", yearsOfExperience: 1)
    }
}
