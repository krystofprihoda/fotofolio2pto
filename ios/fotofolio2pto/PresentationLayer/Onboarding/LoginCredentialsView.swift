//
//  LoginCredentialsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct LoginCredentialsView: View {
    @Binding var email: String
    @Binding var password: String
    
    @State var hiddenPassword = true
    
    var body: some View {
        VStack(spacing: Constants.Dimens.spaceLarge) {
            TextField(L.Onboarding.email, text: $email)
                .font(.body)
                .frame(height: Constants.Dimens.textFieldHeight)
                .padding()
                .background(.textFieldBackground)
                .cornerRadius(Constants.Dimens.radiusXSmall)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            ZStack(alignment: .trailing) {
                if hiddenPassword {
                    SecureField(L.Onboarding.password, text: $password)
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .padding()
                        .background(.textFieldBackground)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        .disableAutocorrection(true)
                } else {
                    TextField(L.Onboarding.password, text: $password)
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .padding()
                        .background(.textFieldBackground)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        .disableAutocorrection(true)
                }
                
                Button(action: { hiddenPassword.toggle() }, label: {
                    Image(systemName: hiddenPassword ? "eye" : "eye.slash")
                        .padding()
                        .foregroundColor(.gray)
                })
                .animation(.default, value: hiddenPassword)
            }
        }
    }
}

#Preview {
    LoginCredentialsView(email: .constant(""), password: .constant(""))
}
