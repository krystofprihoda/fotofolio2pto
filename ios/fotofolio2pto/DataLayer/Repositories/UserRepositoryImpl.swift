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
        let queryParams = query.isEmpty ? nil : ["query": query]
        
        let netUsers: [NETUser] = try await network.fetch(
            endpoint: .user,
            method: .GET,
            body: nil,
            headers: nil,
            queryParams: queryParams,
            auth: true
        )
        return try netUsers.map { try $0.domainModel }
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
            queryParams: queryParams,
            auth: false // This endpoint doesn't require authentication
        )
    }
    
    public func createUser(username: String, email: String, fullName: String, location: String, profilePicture: String) async throws {
        guard let userId: String = encryptedStorage.read(.userId) else { throw AuthError.missingUserId }
        
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
            headers: nil,
            queryParams: nil,
            auth: true
        )
    }
    
    public func getUser(id: String) async throws -> User {
        let netUser: NETUser = try await network.fetch(
            endpoint: .userById(id),
            method: .GET,
            body: [:],
            headers: nil,
            queryParams: nil,
            auth: true
        )
        return try netUser.domainModel
    }
    
    public func updateUserData(location: String) async throws {
        guard let userId: String = encryptedStorage.read(.userId) else { throw AuthError.missingUserId }
        
        let body: [String:String] = [
            "location": location
        ]
        
        let _ = try await network.request(endpoint: .userById(userId), method: .PATCH, body: body, headers: nil, queryParams: nil, auth: true)
    }
    
    public func saveUserProfilePicture(image: UIImage) async throws {
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
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        _ = try await network.request(
            endpoint: .userProfilePicture(userId),
            method: .POST,
            rawBody: body,
            headers: headers,
            queryParams: nil,
            auth: true
        )
    }
    
    public func giveRatingToUser(receiverId: String, rating: Int) async throws {
        let body: [String:String] = [
            "rating": String(rating)
        ]
        
        let _ = try await network.request(endpoint: .userRating(receiverId), method: .POST, body: body, headers: nil, queryParams: nil, auth: true)
    }
}
