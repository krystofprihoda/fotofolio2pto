//
//  FeedRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import UIKit
import Foundation

public class FeedRepositoryImpl: FeedRepository {
    
    private let defaults: UserDefaultsProvider
    private let network: NetworkProvider
    
    init(defaults: UserDefaultsProvider, network: NetworkProvider) {
        self.defaults = defaults
        self.network = network
    }
    
    public func readAll(categories: [String]? = nil, sortBy: SortByEnum? = nil) async throws -> [Portfolio] {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        var queryParams: [String: String] = [:]
        
        if let categories = categories, !categories.isEmpty {
            var commaCategories = ""
            for category in categories {
                commaCategories += category + ","
            }
            commaCategories.removeLast()
            queryParams["category"] = commaCategories
        }
        
        if let sortBy = sortBy {
            switch sortBy {
            case .date:
                queryParams["sortBy"] = "timestamp"
            case .rating:
                queryParams["sortBy"] = "rating"
            }
        }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let portfolios: [Portfolio] = try await network.fetch(
            endpoint: .portfolio,
            method: .GET,
            body: nil,
            headers: headers,
            queryParams: queryParams
        )
        return portfolios
    }
    
    public func updatePortfolio(id: String, name: String, photos: [String], description: String, category: [String]) async throws -> Portfolio {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        var body: [String:String] = [
            "name": name,
            "description": description
        ]
        
        if !category.isEmpty {
            var commaCategories = ""
            for c in category {
                commaCategories += c + ","
            }
            
            commaCategories.removeLast()
            body["category"] = commaCategories
        }
        if !photos.isEmpty {
            var commaPhotos = ""
            for photo in photos {
                commaPhotos += photo + ","
            }
            
            commaPhotos.removeLast()
            body["photoURLs"] = commaPhotos
        }
        
        
        let updated: Portfolio = try await network.fetch(endpoint: .portfolioById(id), method: .PUT, body: body, headers: headers, queryParams: nil)
        return updated
    }
    
    public func readImageFromURL(url: String) async throws -> UIImage {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let imageData = try await network.fetchImageData(url: url, headers: headers)
        guard let image = UIImage(data: imageData) else { throw NetworkError.decodingError }
        return image
    }
    
    public func addToFlagged(portfolioId: String) throws {
        var flagged = readFlaggedIds()
        guard !flagged.contains(where: { $0 == portfolioId }) else { return }
        flagged.append(portfolioId)
        defaults.update(.flagged, value: flagged)
    }
    
    public func removeFromFlagged(portfolioId: String) throws {
        var flagged = readFlaggedIds()
        flagged.removeAll(where: { $0 == portfolioId })
        defaults.update(.flagged, value: flagged)
    }
    
    public func readFlagged() async throws -> [Portfolio] {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let ids = readFlaggedIds()
        var queryParams: [String: String] = [:]
        
        if !ids.isEmpty {
            var commaIds = ""
            for id in ids {
                commaIds += id + ","
            }
            commaIds.removeLast()
            queryParams["id"] = commaIds
        }
        
        let portfolios: [Portfolio] = try await network.fetch(
            endpoint: .portfolio,
            method: .GET,
            body: nil,
            headers: headers,
            queryParams: queryParams
        )
        return portfolios
    }
        
    public func readFlaggedIds() -> [String] {
        return defaults.read(.flagged) ?? []
    }
    
    public func removeAllFlagged() throws {
        defaults.delete(.flagged)
    }
    
    public func createPortfolio(creatorId: String, name: String, photos: [IImage], description: String, category: [String]) async throws {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }

        let boundary = UUID().uuidString
        var body = Data()

        // Append text fields
        body.appendFormField(name: "creatorId", value: creatorId, boundary: boundary)
        body.appendFormField(name: "name", value: name, boundary: boundary)
        body.appendFormField(name: "description", value: description, boundary: boundary)
        body.appendFormField(name: "category", value: category.joined(separator: ","), boundary: boundary)

        // Append images
        for (index, iimage) in photos.enumerated() {
            guard case .local(let image) = iimage.src else {
                continue
            }
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }

            let boundaryPrefix = "--\(boundary)\r\n"
            body.append(Data(boundaryPrefix.utf8))
            body.append(Data("Content-Disposition: form-data; name=\"photo\(index)\"; filename=\"photo\(index).jpg\"\r\n".utf8))
            body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
            body.append(imageData)
            body.append(Data("\r\n".utf8))  // Important newline
        }

        body.append(Data("--\(boundary)--\r\n".utf8))

        let headers = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        _ = try await network.request(
            endpoint: .portfolio,
            method: .POST,
            rawBody: body,
            headers: headers,
            queryParams: nil
        )
    }
    
    public func removePortfolio(id: String) async throws {
        guard let token: String = defaults.read(.token) else { throw AuthError.tokenRetrievalFailed }
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let _ = try await network.request(endpoint: .portfolioById(id), method: .DELETE, body: nil, headers: headers, queryParams: nil)
    }
}
