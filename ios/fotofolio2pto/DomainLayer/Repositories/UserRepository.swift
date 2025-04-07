//
//  UserRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation
import UIKit

public protocol UserRepository {
    func createUser(username: String, email: String, fullName: String, location: String, profilePicture: String) async throws
    func getUser(id: String) async throws -> User
    func saveSignedInUsername(_ username: String)
    func getSignedInUsername() throws -> String
    func getUsersFromQuery(query: String) async throws -> [User]
    func updateUserData(location: String) async throws
    func saveUserProfilePicture(image: UIImage) async throws
    func giveRatingToUser(receiverId: String, rating: Int) async throws
    func isUsernameTaken(_ username: String) async throws
}
