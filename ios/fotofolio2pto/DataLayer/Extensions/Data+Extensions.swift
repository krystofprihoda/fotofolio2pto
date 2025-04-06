//
//  Data+Extensions.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 06.04.2025.
//

import Foundation

extension Data {
    mutating func appendFormField(name: String, value: String, boundary: String) {
        let boundaryPrefix = "--\(boundary)\r\n"
        self.append(Data(boundaryPrefix.utf8))
        self.append(Data("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".utf8))
        self.append(Data("\(value)\r\n".utf8))
    }
}
