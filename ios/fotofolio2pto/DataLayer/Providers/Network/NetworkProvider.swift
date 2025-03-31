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

enum Endpoint {
    case user
    case userById(String)
    case creator
    case creatorById(String)
    case creatorPortfolios(creatorId: String)
    case userByCreatorId(String)
    case portfolio
    
    var path: String {
        switch self {
        case .user:
            return "/user"
        case .userById(let id):
            return "/user/\(id)"
        case .creator:
            return "/creator"
        case .creatorById(let id):
            return "/creator/\(id)"
        case .creatorPortfolios(let id):
            return "/creator/\(id)/portfolio"
        case .userByCreatorId(let id):
            return "/creator/\(id)/user"
        case .portfolio:
            return "/portfolio"
        }
    }
}

protocol NetworkProvider {
    func request(endpoint: Endpoint, method: HTTPMethod, body: [String: Any]?, headers: [String: String]?, queryParams: [String: String]?) async throws -> Data
    func fetch<T: Decodable>(endpoint: Endpoint, method: HTTPMethod, body: [String: Any]?, headers: [String: String]?, queryParams: [String: String]?) async throws -> T
}
