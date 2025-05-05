//
//  AuthError.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 05.05.2025.
//

enum AuthError: Error {
    case emailAlreadyTaken
    case registrationFailed
    case tokenRetrievalFailed
    case wrongCredentials
    case missingUserId
}
