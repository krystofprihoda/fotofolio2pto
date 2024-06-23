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
    @State var passwordSecond: String = "pwd"
    
    @State var hiddenPassword = true
    
    @Binding var fillUsernameAlert: Bool
    @Binding var passwordAlert: Bool
    
    @State var showPasswordDisclaimer = false
    
    var body: some View {
        VStack {
            Text("Uživatelské jméno")
                .brightness(0.27)
            
            TextField("Uživatelské jméno", text: $username)
                .font(.system(size: 18))
                .frame(height: 38)
                .offset(x: 9)
                .padding()
                .background(.gray).brightness(0.35)
                .cornerRadius(9)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(.red, lineWidth: 1)
                        .opacity(fillUsernameAlert ? 1 : 0)
                )
            
            Text("Heslo")
                .brightness(0.27)
            
            ZStack(alignment: .trailing) {
                if hiddenPassword {
                    SecureField("Heslo", text: $password)
                        .textContentType(.oneTimeCode)
                        .font(.system(size: 18))
                        .frame(height: 38)
                        .offset(x: 9)
                        .padding()
                        .background(.gray).brightness(0.35)
                        .cornerRadius(9)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(.red, lineWidth: 1)
                                .opacity(passwordAlert ? 1 : 0)
                        )
                } else {
                    TextField("Heslo", text: $password)
                        .font(.system(size: 18))
                        .frame(height: 38)
                        .offset(x: 9)
                        .padding()
                        .background(.gray).brightness(0.35)
                        .cornerRadius(9)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 9)
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
