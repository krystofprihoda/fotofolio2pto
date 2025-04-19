//
//  TextFieldView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 19.04.2025.
//

import SwiftUI

struct TextFieldView: View {
    
    private let title: String
    private let text: Binding<String>
    
    init(title: String, text: Binding<String>) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        TextField(title, text: text)
            .font(.body)
            .frame(height: Constants.Dimens.textFieldHeight)
            .padding(Constants.Dimens.spaceLarge)
            .background(.textFieldBackground)
            .cornerRadius(Constants.Dimens.radiusXSmall)
    }
}
