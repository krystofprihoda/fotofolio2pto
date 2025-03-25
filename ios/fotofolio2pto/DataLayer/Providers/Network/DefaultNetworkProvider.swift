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
    
    func request(endpoint: Endpoint, method: HTTPMethod, body: [String: Any]?, headers: [String: String]?) async throws -> Data {
        guard let url = URL(string: "\(baseURL.rawValue)\(endpoint.path)") else {
            throw URLError(.badURL)
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
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Request failed"])
        }
        
        return data
    }
}

