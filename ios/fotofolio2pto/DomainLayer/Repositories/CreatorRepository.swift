//
//  CreatorRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.03.2025.
//

import Foundation

public protocol CreatorRepository {
    func readCreator(id: String) async throws -> Creator
    func createCreator(yearsOfExperience: Int) async throws
    func readUserByCreatorId(creatorId: String) async throws -> User
    func readAllCreatorPortfolios(creatorId: String) async throws -> [Portfolio]
}
