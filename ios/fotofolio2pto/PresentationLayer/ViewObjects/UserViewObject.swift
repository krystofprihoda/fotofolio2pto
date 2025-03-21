//
//  UserViewObject.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 15.03.2025.
//

import SwiftUI

class UserViewObject: Identifiable, ObservableObject {
    
    var id: Int?
    var username: String
    var fullName: String
    var email: String
    var location: String
    var profilePicture: IImage?
    var ratings: [String:Int]
    var creator: Creator?
    
    public init(
        id: Int? = nil,
        username: String,
        fullName: String,
        email: String,
        location: String,
        profilePicture: IImage? = nil,
        ratings: [String : Int],
        creator: Creator? = nil
    ) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.email = email
        self.location = location
        self.profilePicture = profilePicture
        self.ratings = ratings
        self.creator = creator
    }
    
    public init(user: User) {
        self.id = user.id
        self.username = user.username
        self.fullName = user.fullName
        self.email = user.email
        self.location = user.location
        self.profilePicture = user.profilePicture
        self.ratings = user.ratings
        self.creator = user.creator
    }
}

extension UserViewObject {
    static var empty: UserViewObject {
        .init(
            username: "",
            fullName: "",
            email: "",
            location: "",
            ratings: [:]
        )
    }
}
