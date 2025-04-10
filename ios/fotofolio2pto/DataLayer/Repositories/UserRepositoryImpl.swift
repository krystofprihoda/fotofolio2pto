//
//  UserRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation
import UIKit

public class UserRepositoryImpl: UserRepository {
    
    private let encryptedStorage: EncryptedLocalStorageProvider
    private let network: NetworkProvider
    
    init(encryptedStorage: EncryptedLocalStorageProvider, network: NetworkProvider) {
        self.encryptedStorage = encryptedStorage
        self.network = network
    }
    
    public func getUsersFromQuery(query: String) async throws -> [User] {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let queryParams = query.isEmpty ? nil : ["query": query]
        
        let users: [User] = try await network.fetch(
            endpoint: .user,
            method: .GET,
            body: nil,
            headers: headers,
            queryParams: queryParams
        )
        return users
    }
    
    public func isUsernameTaken(_ username: String) async throws {
        let queryParams: [String:String] = [
            "username": username
        ]
        
        _ = try await network.request(
            endpoint: .usernameAvailable,
            method: .GET,
            body: nil,
            headers: nil,
            queryParams: queryParams
        )
    }
    
    public func createUser(username: String, email: String, fullName: String, location: String, profilePicture: String) async throws {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        guard let userId: String = encryptedStorage.read(.userId) else { throw AuthError.missingUserId }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let body: [String: String] = [
            "id": userId,
            "username": username,
            "email": email,
            "fullName": fullName,
            "profilePicture": profilePicture
        ]
        
        _ = try await network.request(
            endpoint: .user,
            method: .POST,
            body: body,
            headers: headers,
            queryParams: nil
        )
    }
    
    public func getUser(id: String) async throws -> User {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let user: User = try await network.fetch(
            endpoint: .userById(id),
            method: .GET,
            body: [:],
            headers: headers,
            queryParams: nil
        )
        return user
    }
    
    public func updateUserData(location: String) async throws {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        guard let userId: String = encryptedStorage.read(.userId) else { throw AuthError.missingUserId }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let body: [String:String] = [
            "location": location
        ]
        
        let _ = try await network.request(endpoint: .userById(userId), method: .PATCH, body: body, headers: headers, queryParams: nil)
    }
    
    public func saveUserProfilePicture(image: UIImage) async throws {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        guard let userId: String = encryptedStorage.read(.userId) else { throw AuthError.missingUserId }
        
        let boundary = UUID().uuidString
        var body = Data()

        guard let imageData = image.jpegData(compressionQuality: 0.8) else { throw ObjectError.imageConversionFailed }

        let boundaryPrefix = "--\(boundary)\r\n"
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"profilepicture\"; filename=\"profilepicture.jpg\"\r\n".utf8))
        body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        body.append(imageData)
        body.append(Data("\r\n".utf8))
        body.append(Data("--\(boundary)--\r\n".utf8))

        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        _ = try await network.request(
            endpoint: .userProfilePicture(userId),
            method: .POST,
            rawBody: body,
            headers: headers,
            queryParams: nil
        )
    }
    
    public func giveRatingToUser(receiverId: String, rating: Int) async throws {
        guard let token: String = encryptedStorage.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let body: [String:String] = [
            "rating": String(rating)
        ]
        
        let _ = try await network.request(endpoint: .userRating(receiverId), method: .POST, body: body, headers: headers, queryParams: nil)
    }
}
