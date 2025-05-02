//
//  BaseTextEditor.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 19.04.2025.
//

import SwiftUI

struct BaseTextEditor: View {
    @Binding private var text: String
    
    @State private var internalText: String
    
    init(text: Binding<String>) {
        self._text = text
        self._internalText = State(initialValue: text.wrappedValue)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                .fill(.textFieldBackground)
            
            TextEditor(text: $internalText)
                .font(.body)
                .lineSpacing(Constants.Dimens.spaceXSmall)
                .foregroundColor(.black)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .padding(.top, Constants.Dimens.spaceSemiMedium)
                .padding(.horizontal, Constants.Dimens.spaceSmall)
                .onChange(of: internalText) { newValue in
                    text = newValue
                }
                .onChange(of: text) { newValue in
                    if newValue != internalText {
                        internalText = newValue
                    }
                }
        }
    }
}
