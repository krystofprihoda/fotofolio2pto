//
//  CheckEmailAddressAvailableUseCase.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 05.03.2025.
//


import Foundation

public protocol CheckEmailAddressAvailableUseCase {
    func execute(_ email: String) async throws
}

public struct CheckEmailAddressAvailableUseCaseImpl: CheckEmailAddressAvailableUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func execute(_ email: String) async throws {
        try await userRepository.isEmailAddressTaken(email)
    }
}
