//
//  AuthRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol AuthRepository {
    func checkEmailAvailable(email: String) async throws
    func registerUser(email: String, password: String) async throws
    func logout() throws
    func loginWithCredentials(email: String, password: String) async throws -> UserAuthDetails
    func readLoggedInUser() -> String?
    func readLastSignedInEmail() -> String
}
