//
//  NETUser.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.05.2025.
//

import Foundation

public struct NETUser: Codable {
    let id: String
    let username: String
    let fullName: String
    let email: String
    let location: String
    let profilePicture: String?
    let rating: [String: Int]
    let creatorId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username, fullName, email, location, profilePicture, rating, creatorId
    }
    
    init(id: String, username: String, fullName: String, email: String, location: String, profilePicture: String?, rating: [String: Int], creatorId: String?) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.email = email
        self.location = location
        self.profilePicture = profilePicture
        self.rating = rating
        self.creatorId = creatorId
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

        if let profilePictureURLString = try? container.decode(String.self, forKey: .profilePicture), !profilePictureURLString.isEmpty {
            profilePicture = profilePictureURLString
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
        try container.encodeIfPresent(profilePicture, forKey: .profilePicture)
    }
}

// Conversion from NetworkModel to DomainModel
extension NETUser: DomainRepresentable {
    public typealias DomainModel = User
    
    public var domainModel: DomainModel {
        get throws {
            let profilePic: IImage? = self.profilePicture != nil && !self.profilePicture!.isEmpty ? 
                                      IImage(src: .remote(self.profilePicture!)) :
                                      nil
            
            return User(
                id: id,
                username: username,
                fullName: fullName,
                email: email,
                location: location,
                profilePicture: profilePic,
                rating: rating,
                creatorId: creatorId
            )
        }
    }
}

// Conversion from DomainModel to NetworkModel
extension User: NetworkRepresentable {
    public typealias NetworkModel = NETUser
    
    public var networkModel: NetworkModel {
        var profilePictureURL: String? = nil
        if let profilePic = profilePicture {
            if case .remote(let url) = profilePic.src {
                profilePictureURL = url
            }
        }
        
        return NETUser(
            id: id,
            username: username,
            fullName: fullName,
            email: email,
            location: location,
            profilePicture: profilePictureURL,
            rating: rating,
            creatorId: creatorId
        )
    }
}
