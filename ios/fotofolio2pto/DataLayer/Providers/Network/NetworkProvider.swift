//
//  NetworkProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.03.2025.
//

import Foundation

enum BaseURL: String {
    case production = "https://api.yourdomain.com"
    case test = "http://0.0.0.0:8080"
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

enum NetworkError: Error {
    case badURL
    case unauthorized
    case notFound
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "Invalid URL."
        case .unauthorized:
            return "Unauthorized request."
        case .notFound:
            return "Requested resource was not found."
        case .serverError(let statusCode):
            return "Server error (status code: \(statusCode))."
        case .decodingError:
            return "Failed to decode response."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

enum Endpoint {
    case user
    case userById(String)
    case userProfilePicture(String)
    case userRating(String)
    case creator
    case creatorById(String)
    case creatorPortfolio(creatorId: String)
    case userByCreatorId(String)
    case portfolio
    case portfolioById(String)
    case chat
    case messageByChatId(String)
    
    var path: String {
        switch self {
        case .user:
            return "/user"
        case .userById(let id):
            return "/user/\(id)"
        case .userProfilePicture(let id):
            return "/user/\(id)/profilepicture"
        case .userRating(let receiverId):
            return "/user/\(receiverId)/rating"
        case .creator:
            return "/creator"
        case .creatorById(let id):
            return "/creator/\(id)"
        case .creatorPortfolio(let id):
            return "/creator/\(id)/portfolio"
        case .userByCreatorId(let id):
            return "/creator/\(id)/user"
        case .portfolio:
            return "/portfolio"
        case .portfolioById(let id):
            return "/portfolio/\(id)"
        case .chat:
            return "/chat"
        case .messageByChatId(let chatId):
            return "/chat/\(chatId)/message"
        }
    }
}

protocol NetworkProvider {
    func request(endpoint: Endpoint, method: HTTPMethod, body: [String: Any]?, headers: [String: String]?, queryParams: [String: String]?) async throws -> Data
    func fetch<T: Decodable>(endpoint: Endpoint, method: HTTPMethod, body: [String: Any]?, headers: [String: String]?, queryParams: [String: String]?) async throws -> T
    func request(endpoint: Endpoint, method: HTTPMethod, rawBody: Data?, headers: [String: String]?, queryParams: [String: String]?) async throws -> Data
    func fetch<T: Decodable>(endpoint: Endpoint, method: HTTPMethod, rawBody: Data?, headers: [String: String]?, queryParams: [String: String]?) async throws -> T
    func fetchImageData(url: String, headers: [String: String]) async throws -> Data
}
