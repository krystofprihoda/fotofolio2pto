//
//  NETCreator.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.05.2025.
//

import Foundation

struct NETCreator: Codable {
    let id: String
    let userId: String
    let description: String
    let yearsOfExperience: Int
    let portfolioIds: [String]
    
    init(id: String, userId: String, description: String, yearsOfExperience: Int, portfolioIds: [String]) {
        self.id = id
        self.userId = userId
        self.description = description
        self.yearsOfExperience = yearsOfExperience
        self.portfolioIds = portfolioIds
    }
}

// Conversion from NetworkModel to DomainModel
extension NETCreator: DomainRepresentable {
    typealias DomainModel = Creator
    
    var domainModel: DomainModel {
        get throws {
            return Creator(
                id: id,
                userId: userId,
                description: description,
                yearsOfExperience: yearsOfExperience,
                portfolioIds: portfolioIds
            )
        }
    }
}

// Conversion from DomainModel to NetworkModel
extension Creator: NetworkRepresentable {
    typealias NetworkModel = NETCreator
    
    var networkModel: NetworkModel {
        return NETCreator(
            id: id,
            userId: userId,
            description: description,
            yearsOfExperience: yearsOfExperience,
            portfolioIds: portfolioIds
        )
    }
}
