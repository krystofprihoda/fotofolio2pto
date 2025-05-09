//
//  SignInCredentialsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct SignInCredentialsView: View {
    @Binding private var email: String
    @Binding private var password: String
    
    private var onClearEmailTap: () -> Void
    
    @State private var hiddenPassword = true
    
    public init(email: Binding<String>, password: Binding<String>, onClearEmailTap: @escaping () -> Void) {
        self._email = email
        self._password = password
        self.onClearEmailTap = onClearEmailTap
    }
    
    var body: some View {
        VStack(spacing: Constants.Dimens.spaceLarge) {
            ZStack(alignment: .trailing) {
                TextFieldView(title: L.Onboarding.email, text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !email.isEmpty {
                    Button(action: onClearEmailTap, label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding(Constants.Dimens.spaceLarge)
                            .foregroundColor(.gray)
                    })
                }
            }
            
            ZStack(alignment: .trailing) {
                if hiddenPassword {
                    SecureField(L.Onboarding.password, text: $password)
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .padding(Constants.Dimens.spaceLarge)
                        .background(.textFieldBackground)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        .disableAutocorrection(true)
                } else {
                    TextFieldView(title: L.Onboarding.password, text: $password)
                        .disableAutocorrection(true)
                }
                
                Button(action: { hiddenPassword.toggle() }, label: {
                    Image(systemName: hiddenPassword ? "eye.slash" : "eye")
                        .padding(Constants.Dimens.spaceLarge)
                        .foregroundColor(.gray)
                })
                .animation(.default, value: hiddenPassword)
            }
        }
    }
}

#Preview {
    SignInCredentialsView(email: .constant(""), password: .constant(""), onClearEmailTap: {})
}
