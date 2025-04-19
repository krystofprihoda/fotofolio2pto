//
//  RegisterNameAndEmailView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 07.03.2025.
//

import SwiftUI

struct RegisterNameAndEmailView: View {
    var name: Binding<String>
    var email: Binding<String>
    var emailError: String
    var emailVerified: Bool
    var showSkeleton: Bool
    var onEmailChanged: () -> Void
    var onNextTap: () -> Void
    
    var body: some View {
        VStack {
            TextFieldView(title: L.Onboarding.name, text: name)
                .disableAutocorrection(true)
            
            TextFieldView(title: L.Onboarding.email, text: email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .onChange(of: email.wrappedValue) { _ in
                    onEmailChanged()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .stroke(.red, lineWidth: 1)
                        .opacity(emailError.isEmpty ? 0 : 1)
                )
            
            if !emailError.isEmpty {
                Text(emailError)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            Button(action: onNextTap, label: {
                Text(L.Onboarding.next)
                    .font(.body)
                    .frame(height: Constants.Dimens.textFieldHeight)
                    .frame(maxWidth: .infinity)
                    .padding(Constants.Dimens.spaceLarge)
                    .foregroundStyle(.white)
                    .background(.mainLight)
                    .cornerRadius(Constants.Dimens.radiusXSmall)
            })
            .disabledOverlay(!emailVerified)
            .skeleton(showSkeleton)
        }
        .animation(.default, value: emailError)
    }
}
