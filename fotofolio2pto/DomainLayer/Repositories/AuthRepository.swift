//
//  AuthRepository.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public protocol AuthRepository {
    func logout()
    func loginWithCredentials(username: String, password: String)
}
