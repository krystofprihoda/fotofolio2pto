//
//  PortfolioRepositoryImpl.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import UIKit
import Foundation

public class PortfolioRepositoryImpl: PortfolioRepository {
    
    private let defaults: LocalStorageProvider
    private let encryptedStorage: EncryptedLocalStorageProvider
    private let network: NetworkProvider
    
    init(defaults: LocalStorageProvider, encryptedStorage: EncryptedLocalStorageProvider, network: NetworkProvider) {
        self.defaults = defaults
        self.encryptedStorage = encryptedStorage
        self.network = network
    }
    
    public func readAll(categories: [String]? = nil, sortBy: SortByEnum? = nil) async throws -> [Portfolio] {
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
        
        let netPortfolios: [NETPortfolio] = try await network.fetch(
            endpoint: .portfolio,
            method: .GET,
            body: nil,
            headers: nil,
            queryParams: queryParams,
            auth: true
        )
        
        return try netPortfolios.map { try $0.domainModel }
    }
    
    public func updatePortfolio(id: String, name: String, photos: [String], price: Price, description: String, category: [String]) async throws -> Portfolio {
        var body: [String:String] = [
            "name": name,
            "description": description
        ]
        
        if case .fixed(let value) = price {
            body["price"] = String(value)
        } else {
            body["price"] = "0"
        }
        
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
            body["photos"] = commaPhotos
        }
        
        let netPortfolio: NETPortfolio = try await network.fetch(endpoint: .portfolioById(id), method: .PUT, body: body, headers: nil, queryParams: nil, auth: true)
        return try netPortfolio.domainModel
    }
    
    public func readImageFromURL(url: String) async throws -> UIImage {
        let imageData = try await network.fetchImageData(url: url, headers: nil, auth: true)
        guard let image = UIImage(data: imageData) else { throw NetworkError.decodingError }
        return image
    }
    
    public func addToFlagged(portfolioId: String) {
        var flagged = readFlaggedIds()
        guard !flagged.contains(where: { $0 == portfolioId }) else { return }
        flagged.append(portfolioId)
        defaults.update(.flagged, value: flagged)
    }
    
    public func removeFromFlagged(portfolioId: String) {
        var flagged = readFlaggedIds()
        flagged.removeAll(where: { $0 == portfolioId })
        defaults.update(.flagged, value: flagged)
    }
    
    public func readFlagged() async throws -> [Portfolio] {
        let ids = readFlaggedIds()
        
        guard !ids.isEmpty else { return [] }
        
        var queryParams: [String: String] = [:]
        
        if !ids.isEmpty {
            var commaIds = ""
            for id in ids {
                commaIds += id + ","
            }
            commaIds.removeLast()
            queryParams["id"] = commaIds
        }
        
        let netPortfolios: [NETPortfolio] = try await network.fetch(
            endpoint: .portfolio,
            method: .GET,
            body: nil,
            headers: nil,
            queryParams: queryParams,
            auth: true
        )
        return try netPortfolios.map { try $0.domainModel }
    }
        
    public func readFlaggedIds() -> [String] {
        return defaults.read(.flagged) ?? []
    }
    
    public func removeAllFlagged() {
        defaults.delete(.flagged)
    }
    
    public func createPortfolio(creatorId: String, name: String, photos: [IImage], price: Price, description: String, category: [String]) async throws {
        let boundary = UUID().uuidString
        var body = Data()
        
        var priceValue = "0"
        if case .fixed(let value) = price {
            priceValue = String(value)
        }

        // Append text fields
        body.appendFormField(name: "creatorId", value: creatorId, boundary: boundary)
        body.appendFormField(name: "name", value: name, boundary: boundary)
        body.appendFormField(name: "description", value: description, boundary: boundary)
        body.appendFormField(name: "price", value: priceValue, boundary: boundary)
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
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        _ = try await network.request(
            endpoint: .portfolio,
            method: .POST,
            rawBody: body,
            headers: headers,
            queryParams: nil,
            auth: true
        )
    }
    
    public func removePortfolio(id: String) async throws {
        let _ = try await network.request(endpoint: .portfolioById(id), method: .DELETE, body: nil, headers: nil, queryParams: nil, auth: true)
    }
}
