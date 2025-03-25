//
//  Logger+Extensions.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 25.03.2025.
//

import OSLog

extension Logger {
    static func log(request: URLRequest) {
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "Unknown URL"
        let body = request.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "No Body"
        
        let requestLog = """
        
        🚀 Request Sent
        ➡️ Method: \(method)
        🔗 URL: \(url)
        📝 Body: \(body)
        
        """
        
        Logger.networking.info("\(requestLog)")
    }
    
    static func log(response: URLResponse, data: Data) {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let url = httpResponse.url?.absoluteString ?? "Unknown URL"
        let statusCode = httpResponse.statusCode
        let statusSymbol = (200...299).contains(statusCode) ? "✅" : "❌"
        let responseBody = String(decoding: data, as: UTF8.self)
        
        let responseLog = """
        
        🎯 Response Received
        ⬅️ URL: \(url)
        \(statusSymbol) Status Code: \(statusCode)
        📄 Body: \(responseBody)
        
        """
        
        Logger.networking.info("\(responseLog)")
    }
}

