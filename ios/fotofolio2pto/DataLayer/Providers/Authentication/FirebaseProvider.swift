//
//  FirebaseProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.03.2025.
//

import FirebaseAuth

enum AuthError: Error {
    case emailAlreadyTaken
    case registrationFailed
    case tokenRetrievalFailed
    case wrongCredentials
    case missingUserId
}

class FirebaseProvider: AuthProvider {
    
    private let auth: Auth = .auth()
    
    func registerUser(email: String, password: String) async throws -> RegisterData {
        return try await withCheckedThrowingContinuation { continuation in
            auth.createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error) // Forward Firebase error
                    return
                }
                
                guard let user = result?.user else {
                    continuation.resume(throwing: AuthError.registrationFailed)
                    return
                }
                
                // Fetch the ID token asynchronously
                user.getIDToken { token, error in
                    if let error = error {
                        continuation.resume(throwing: error) // Forward Firebase error
                    } else if let token = token {
                        continuation.resume(returning: RegisterData(uid: user.uid, token: token, email: user.email))
                    } else {
                        continuation.resume(throwing: AuthError.tokenRetrievalFailed)
                    }
                }
            }
        }
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        return try await withCheckedThrowingContinuation { continuation in
            auth.signIn(withEmail: email, password: password) { result, error in
                if let error = error as NSError? {
                    if error.domain == AuthErrorDomain,
                       let code = AuthErrorCode(rawValue: error.code) {
                        switch code {
                        case .wrongPassword, .invalidEmail, .userNotFound, .invalidCredential:
                            continuation.resume(throwing: AuthError.wrongCredentials)
                        default:
                            continuation.resume(throwing: error)
                        }
                        return
                    }
                    
                    continuation.resume(throwing: error) // fallback
                    return
                }
                
                if let result = result {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: AuthError.tokenRetrievalFailed)
                }
            }
        }
    }
    
    func logout() throws {
        try auth.signOut()
    }
    
    func checkEmailAvailable(_ email: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            auth.fetchSignInMethods(forEmail: email) { (methods, error) in
                if let error = error {
                    continuation.resume(throwing: error) // Forward Firebase error
                    return
                }
                
                if let methods = methods, !methods.isEmpty {
                    continuation.resume(throwing: AuthError.emailAlreadyTaken) // Email is taken
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
