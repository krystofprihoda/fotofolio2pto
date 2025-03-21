//
//  ObjectError.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 24.06.2024.
//

import Foundation

public enum ObjectError: Error, Equatable {
    case nonExistent
    case emailAlreadyTaken
    case usernameAlreadyTaken
}
