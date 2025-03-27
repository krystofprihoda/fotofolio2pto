//
//  UserRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol UserRepository {
    func createUser(username: String, email: String, fullName: String, location: String, profilePicture: String) async throws
    func getUser(id: String) async throws -> User
    func saveSignedInUsername(_ username: String)
    func getSignedInUsername() throws -> String
    func getUserByUsername(_ username: String) async throws -> User?
    func getUsersFromUsernameQuery(query: String) async throws -> [User]
    func getUsersFromLocationQuery(query: String) async throws -> [User]
    func isEmailAddressTaken(_ email: String) async throws
    func isUsernameTaken(_ username: String) async throws
}
