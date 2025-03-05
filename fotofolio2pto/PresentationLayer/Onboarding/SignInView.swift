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
                Text(L.Onboarding.signIn)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 1)
                
                Button(action: {
                    viewModel.onIntent(.registerUser)
                }, label: {
                    Text(L.Onboarding.registrationAlternative)
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
            
//                ZStack {
//                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
//                        .fill(.gray)
//                }
//                .frame(width: Constants.Dimens.frameSizeXXXLarge, height: Constants.Dimens.frameSizeMedium)
            
            Button(action: {
                viewModel.onIntent(.signIn)
            }) {
                Text(L.Onboarding.signInAction)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 100)
                    .padding([.top, .bottom], 15)
                    .background(.black).brightness(0.13)
                    .cornerRadius(9)
            }
            .padding(.top, 9)
        }
        .padding([.leading, .trailing], 25)
        .setupNavBarAndTitle("")
    }
}

#Preview {
    SignInView(viewModel: .init(flowController: nil))
}
