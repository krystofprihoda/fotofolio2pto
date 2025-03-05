//
//  LoginCredentialsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct LoginCredentialsView: View {
    @Binding var username: String
    @Binding var password: String
    @State var passwordSecond: String = ""
    
    @State var hiddenPassword = true
    
    @Binding var fillUsernameAlert: Bool
    @Binding var passwordAlert: Bool
    
    @State var showPasswordDisclaimer = false
    
    var body: some View {
        VStack {
//            Text(L.Onboarding.username)
//                .brightness(0.27)
            
            TextField(L.Onboarding.username, text: $username)
                .font(.body)
                .frame(height: 38)
                .offset(x: 9)
                .padding()
                .background(.gray).brightness(0.35)
                .cornerRadius(Constants.Dimens.radiusXSmall)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .stroke(.red, lineWidth: 1)
                        .opacity(fillUsernameAlert ? 1 : 0)
                )
                .padding(.bottom)
            
//            Text(L.Onboarding.password)
//                .brightness(0.27)
            
            ZStack(alignment: .trailing) {
                if hiddenPassword {
                    SecureField(L.Onboarding.password, text: $password)
                        .textContentType(.oneTimeCode)
                        .font(.body)
                        .frame(height: 38)
                        .offset(x: 9)
                        .padding()
                        .background(.gray).brightness(0.35)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                .stroke(.red, lineWidth: 1)
                                .opacity(passwordAlert ? 1 : 0)
                        )
                } else {
                    TextField(L.Onboarding.password, text: $password)
                        .font(.system(size: 18))
                        .frame(height: 38)
                        .offset(x: 9)
                        .padding()
                        .background(.gray).brightness(0.35)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                .stroke(.red, lineWidth: 1)
                                .opacity(passwordAlert ? 1 : 0)
                        )
                }
                
                Button(action: { withAnimation { hiddenPassword.toggle() } }, label: {
                    Image(systemName: hiddenPassword ? "eye" : "eye.slash")
                        .padding(.trailing, 17)
                        .foregroundColor(.gray)
                })
            }
        }
    }
}

#Preview {
    LoginCredentialsView(username: .constant(""), password: .constant(""), fillUsernameAlert: .constant(true), passwordAlert: .constant(true))
}
