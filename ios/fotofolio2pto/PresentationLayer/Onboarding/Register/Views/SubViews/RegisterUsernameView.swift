//
//  RegisterUsernameView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 10.03.2025.
//

import SwiftUI

struct RegisterUsernameView: View {
    var username: Binding<String>
    var usernameError: String
    var usernameVerified: Bool
    var showSkeleton: Bool
    var onUsernameChanged: () -> Void
    var onBackTap: () -> Void
    var onNextTap: () -> Void
    
    var body: some View {
        VStack {
            TextFieldView(title: L.Onboarding.usernameEng, text: username)
                .disableAutocorrection(true)
                .onChange(of: username.wrappedValue) { _ in
                    onUsernameChanged()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .stroke(.red, lineWidth: 1)
                        .opacity(usernameError.isEmpty ? 0 : 1)
                )
            
            if !usernameError.isEmpty {
                Text(usernameError)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            HStack {
                Button(action: onBackTap, label: {
                    BaseButton(L.General.back)
                })
                
                Button(action: onNextTap, label: {
                    BaseButton(L.Onboarding.next)
                })
                .disabledOverlay(!usernameVerified)
                .skeleton(showSkeleton)
            }
        }
        .animation(.default, value: usernameError)
    }
}
