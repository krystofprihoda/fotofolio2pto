//
//  SignInView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject private var viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                //Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 9)
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 10)
                        .foregroundColor(.gray).brightness(0.15)
                    
                    if viewModel.state.isSigningIn {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
                
                VStack {
                    Text("Přihlášení.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 1)
                    
                    Button(action: {
                        // RegisterUserView()
                    }, label: {
                        Text("nebo registrace zde")
                            .foregroundColor(.gray)
                            .font(.system(size: 13))
                            .underline()
                    })
                }
                .padding(.bottom)
                
                LoginCredentialsView(
                    username: Binding(get: { viewModel.state.username }, set: { viewModel.onIntent(.setUsername($0)) }),
                    password: Binding(get: { viewModel.state.password }, set: { viewModel.onIntent(.setPassword($0)) }),
                    fillUsernameAlert: .constant(false),
                    passwordAlert: .constant(false)
                )
                
                // Move to whisper/alert
//                Text("Uživatelské jméno neexistuje!")
//                Text("Nesprávné heslo!")
                
                if !viewModel.state.error.isEmpty {
                    Text(viewModel.state.error)
                        .foregroundColor(.red)
                        .font(.system(size: 13))
                        .padding(.top)
                }
                
                Button(action: {
                    viewModel.onIntent(.signIn)
                }) {
                    Text("Přihlásit se")
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 100)
                        .padding([.top, .bottom], 15)
                        .background(.black).brightness(0.13)
                        .cornerRadius(9)
                }
                .padding(.top, 9)
            }
            .padding([.leading, .trailing], 25)
        }
    }
}

#Preview {
    SignInView(viewModel: .init(flowController: nil))
}
