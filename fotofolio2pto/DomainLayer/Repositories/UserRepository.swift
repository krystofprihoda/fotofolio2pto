//
//  UserRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation

public protocol UserRepository {
    func getUserByUsername(_ username: String) async throws -> User?
    func getUsersFromUsernameQuery(query: String, type: SearchOption) async throws -> [User]
    func getUsersFromLocationQuery(query: String, type: SearchOption) async throws -> [User]
}
