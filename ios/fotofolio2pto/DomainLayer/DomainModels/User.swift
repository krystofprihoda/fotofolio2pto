//
//  User.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation

public struct User: Identifiable, Equatable {
    public var id: String
    public var username: String
    public var fullName: String
    public var email: String
    public var location: String
    public var profilePicture: IImage?
    public var rating: [String:Int]
    public var creatorId: String?
    
    public init(
        id: String,
        username: String,
        fullName: String,
        email: String,
        location: String,
        profilePicture: IImage? = nil,
        rating: [String: Int] = [:],
        creatorId: String? = nil
    ) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.email = email
        self.location = location
        self.profilePicture = profilePicture
        self.rating = rating
        self.creatorId = creatorId
    }
    
    public var averageRating: Double {
        if rating.isEmpty { return 0 }
        
        let sum = rating.values.reduce(0, +)
        return Double(sum) / Double(rating.count)
    }
    
    public var isCreator: Bool {
        return creatorId != nil
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id, username, fullName, email, location, profilePicture, rating, creatorId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        fullName = try container.decode(String.self, forKey: .fullName)
        email = try container.decode(String.self, forKey: .email)
        location = try container.decode(String.self, forKey: .location)
        rating = try container.decode([String: Int].self, forKey: .rating)
        
        let rawCreatorId = try container.decodeIfPresent(String.self, forKey: .creatorId)
        if let rawCreatorId, !rawCreatorId.isEmpty {
            creatorId = rawCreatorId
        } else {
            creatorId = nil
        }

        // Decode profilePicture as a URL and wrap it in MyImageEnum.remote
        if let profilePictureURLString = try? container.decode(String.self, forKey: .profilePicture), !profilePictureURLString.isEmpty {
            profilePicture = IImage(src: .remote(profilePictureURLString))
        } else {
            profilePicture = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(email, forKey: .email)
        try container.encode(location, forKey: .location)
        try container.encode(rating, forKey: .rating)
        try container.encodeIfPresent(creatorId, forKey: .creatorId)

        // Encode profilePicture as a URL string
        if let profilePicture = profilePicture,
           case .remote(let url) = profilePicture.src {
            try container.encode(url, forKey: .profilePicture)
        }
    }
}

extension User {
    static let PROFILE_PIC = "https://loremflickr.com/320/320/person"
    
    static let sampleData: [User] = [dummy1, dummy2]
    
    static var dummy1: User {
        User(id: "0", username: "vojtafoti", fullName: "Vojta Votruba", email: "vojtano@mail.com", location: "Praha",
             profilePicture: IImage(src: .remote(PROFILE_PIC)), rating: ["ad.fotograf": 5, "michal1": 4], creatorId: "0")
    }
    
    static var dummy2: User {
        User(id: "1", username: "ad.fotograf", fullName: "Adam Lupínek", email: "adam@mail.cz", location: "Kladno",
             profilePicture: IImage(src: .remote(PROFILE_PIC)), rating: ["eatinkriss": 5], creatorId: "1")
    }
}
