//
//  NetworkError.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 05.05.2025.
//


enum NetworkError: Error {
    case badURL
    case unauthorized
    case notFound
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
    case alreadyTaken
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "Neplatná URL."
        case .unauthorized:
            return "Neoprávněný požadavek."
        case .notFound:
            return "Zdroj požadavku nebyl nalezen."
        case .serverError(let statusCode):
            return "Chyba serveru (status: \(statusCode))."
        case .decodingError:
            return "Chyba při zpracování odpovědi."
        case .unknownError:
            return "Došlo k neznámé chybě."
        case .alreadyTaken:
            return "Zdroj už existuje."
        }
    }
}