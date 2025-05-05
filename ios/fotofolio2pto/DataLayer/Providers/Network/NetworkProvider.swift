//
//  NetworkProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.03.2025.
//

import Foundation

enum BaseURL: String {
    case localhost = "http://0.0.0.0:8080"
    case alpha = "https://fotofolio2pto-alpha.up.railway.app"
    case prod = ""
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

enum Endpoint {
    case user
    case userById(String)
    case userProfilePicture(String)
    case userRating(String)
    case usernameAvailable
    case creator
    case creatorById(String)
    case creatorPortfolio(creatorId: String)
    case userByCreatorId(String)
    case portfolio
    case portfolioById(String)
    case chat
    case chatRead(String)
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
        case .usernameAvailable:
            return "/user/available"
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
        case .chatRead(let chatId):
            return "/chat/\(chatId)/read"
        case .messageByChatId(let chatId):
            return "/chat/\(chatId)/message"
        }
    }
}

protocol NetworkProvider {
    func request(endpoint: Endpoint, method: HTTPMethod, body: [String: Any]?, headers: [String: String]?, queryParams: [String: String]?, auth: Bool) async throws -> Data
    func fetch<T: Decodable>(endpoint: Endpoint, method: HTTPMethod, body: [String: Any]?, headers: [String: String]?, queryParams: [String: String]?, auth: Bool) async throws -> T
    func request(endpoint: Endpoint, method: HTTPMethod, rawBody: Data?, headers: [String: String]?, queryParams: [String: String]?, auth: Bool) async throws -> Data
    func fetch<T: Decodable>(endpoint: Endpoint, method: HTTPMethod, rawBody: Data?, headers: [String: String]?, queryParams: [String: String]?, auth: Bool) async throws -> T
    func fetchImageData(url: String, headers: [String: String]?, auth: Bool) async throws -> Data
}
