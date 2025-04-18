//
//  Text+Extensions.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 18.04.2025.
//

import SwiftUI

extension Text {
    init(spaceSeparatedPrice number: Int, currency: String = L.Selection.czk) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let formatted = formatter.string(from: NSNumber(value: number)) ?? "\(number)"
        self.init(formatted + currency)
    }
}
