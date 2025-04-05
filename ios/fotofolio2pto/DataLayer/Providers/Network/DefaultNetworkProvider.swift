//
//  DefaultNetworkProvider.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.03.2025.
//

import Foundation
import OSLog

final class DefaultNetworkProvider: NetworkProvider {
    
    private let baseURL: BaseURL
    
    init(baseURL: BaseURL = .test) {
        self.baseURL = baseURL
    }
    
    func request(endpoint: Endpoint, method: HTTPMethod, rawBody: Data?, headers: [String: String]?, queryParams: [String: String]? = nil) async throws -> Data {
        guard var urlComponents = URLComponents(string: "\(baseURL.rawValue)\(endpoint.path)") else {
            throw NetworkError.badURL
        }
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = rawBody, method != .GET {
            request.httpBody = body
        }
        
        if baseURL == .test { Logger.log(request: request) }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if baseURL == .test { Logger.log(response: response, data: data) }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.unknownError
        }
    }
    
    func fetch<T: Decodable>(endpoint: Endpoint, method: HTTPMethod = .GET, rawBody: Data? = nil, headers: [String: String]? = nil, queryParams: [String: String]? = nil) async throws -> T {
        let data = try await request(
            endpoint: endpoint,
            method: method,
            rawBody: rawBody,
            headers: headers,
            queryParams: queryParams
        )
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func request(endpoint: Endpoint, method: HTTPMethod, body: [String: Any]? = nil, headers: [String: String]?, queryParams: [String: String]? = nil) async throws -> Data {
        guard var urlComponents = URLComponents(string: "\(baseURL.rawValue)\(endpoint.path)") else {
            throw NetworkError.badURL
        }
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = body, method != .GET {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if baseURL == .test { Logger.log(request: request) }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if baseURL == .test { Logger.log(response: response, data: data) }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.unknownError
        }
    }
        
    func fetch<T: Decodable>(endpoint: Endpoint, method: HTTPMethod = .GET, body: [String: Any]? = nil, headers: [String: String]? = nil, queryParams: [String: String]? = nil) async throws -> T {
        let data = try await request(
            endpoint: endpoint,
            method: method,
            body: body,
            headers: headers,
            queryParams: queryParams
        )
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func fetchImageData(url: String, headers: [String: String]) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkError.badURL }
        
        var request = URLRequest(url: url)
        
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        
        if baseURL == .test { Logger.log(request: request) }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if baseURL == .test { Logger.log(response: response, data: data) }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        return data
    }
}
