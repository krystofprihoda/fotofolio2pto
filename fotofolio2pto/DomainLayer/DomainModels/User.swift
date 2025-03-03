//
//  User.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation

let PROFILE_PIC = URL(string: "https://loremflickr.com/320/320/person")!

public struct User: Identifiable, Equatable {
    public let id: Int
    public let username: String
    public let fullName: String
    public let email: String
    public let location: String
    public let profilePicture: IImage?
    public let ratings: [String:Int]
    public var creator: Creator?
    
    public var averageRating: Double {
        if ratings.isEmpty { return 0 }
        
        let sum = ratings.values.reduce(0, +)
        return Double(sum) / Double(ratings.count)
    }
    
    public var isCreator: Bool {
        return creator != nil
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

extension User {
    static let sampleData: [User] = [dummy1, dummy2, dummy3, dummy4, dummy5, dummy6]
    
    static var dummy1: User {
        User(id: 0, username: "vojtafoti", fullName: "Vojta Votruba", email: "vojtano@mail.com", location: "Praha",
             profilePicture: IImage(src: .remote(PROFILE_PIC)), ratings: ["ad.fotograf": 5, "michal1": 4], creator: Creator.dummy1)
    }
    
    static var dummy2: User {
        User(id: 1, username: "ad.fotograf", fullName: "Adam Lupínek", email: "adam@mail.cz", location: "Kladno",
             profilePicture: IImage(src: .remote(PROFILE_PIC)), ratings: ["eatinkriss": 5], creator: Creator.dummy2)
    }
    
    static var dummy3: User {
        User(id: 2, username: "karel__foti", fullName: "Karel Kovář", email: "karel@mail.com", location: "Buštěhrad",
             profilePicture: IImage(src: .remote(PROFILE_PIC)), ratings: ["milos": 2], creator: Creator.dummy3)
    }
    
    static var dummy4: User {
        User(id: 3, username: "majkl_98", fullName: "Michal Filip", email: "mike@mail.cz", location: "Kolín",
             profilePicture: IImage(src: .remote(PROFILE_PIC)), ratings: [:])
    }
    
    static var dummy5: User {
        User(id: 4, username: "nejfotograf", fullName: "Miroslav Koch", email: "mira@mail.cz", location: "Velké Karlovice",
             profilePicture: IImage(src: .remote(PROFILE_PIC)), ratings: [:], creator: Creator.dummy4)
    }
    
    static var dummy6: User {
        User(id: 5, username: "portretyodmilana", fullName: "Milan Drát", email: "milan@mail.cz", location: "Velvary",
             profilePicture: IImage(src: .remote(PROFILE_PIC)), ratings: ["majkl_98": 5], creator:
             Creator.dummy5)
    }
    
    static var dummy7: User {
        User(id: 6, username: "fotimcvakam", fullName: "Radek Kříž", email: "fotcvakam@mail.cz", location: "Praha",
             profilePicture: IImage(src: .remote(PROFILE_PIC)), ratings: [:])
    }
}
