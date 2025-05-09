//
//  BaseButton.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 09.05.2025.
//

import SwiftUI

struct BaseButton: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.body)
            .frame(height: Constants.Dimens.textFieldHeight)
            .frame(maxWidth: .infinity)
            .padding(Constants.Dimens.spaceLarge)
            .foregroundStyle(.white)
            .background(.mainLight)
            .cornerRadius(Constants.Dimens.radiusXSmall)
    }
}
