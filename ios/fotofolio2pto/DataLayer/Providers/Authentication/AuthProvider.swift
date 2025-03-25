//
//  AuthProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.03.2025.
//

import FirebaseAuth

protocol AuthProvider {
    func checkEmailAvailable(_ email: String) async throws
    func registerUser(email: String, password: String) async throws -> RegisterData
    func createUser(username: String) async throws
    func login(email: String, password: String) async throws -> AuthDataResult
    func logout() throws
}
