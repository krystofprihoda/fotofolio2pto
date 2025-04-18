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
        ZStack(alignment: .center) {
            SignInBackgroundView()
            
            VStack(spacing: Constants.Dimens.spaceLarge) {
                FotofolioAnimatedLogoView()
                
                Text(L.Onboarding.signIn)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, Constants.Dimens.spaceNone)
                
                VStack {
                    VStack(spacing: Constants.Dimens.spaceLarge) {
                        if viewModel.state.isSigningIn {
                            PulsingCircleView()
                                .frame(width: Constants.Dimens.frameSizeXLarge, height: Constants.Dimens.frameSizeXLarge)
                        } else {
                            if !viewModel.state.error.isEmpty {
                                Text(viewModel.state.error)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                            
                            LoginCredentialsView(
                                email: Binding(get: { viewModel.state.email }, set: { viewModel.onIntent(.setEmail($0)) }),
                                password: Binding(get: { viewModel.state.password }, set: { viewModel.onIntent(.setPassword($0)) }),
                                onClearEmailTap: { viewModel.onIntent(.setEmail("")) }
                            )
                            
                            Button(action: { viewModel.onIntent(.signIn) }, label: {
                                Text(L.Onboarding.signInAction)
                                    .font(.body)
                                    .frame(height: Constants.Dimens.textFieldHeight)
                                    .frame(maxWidth: .infinity)
                                    .padding(Constants.Dimens.spaceLarge)
                                    .foregroundStyle(.white)
                                    .background(.mainAccent)
                                    .cornerRadius(Constants.Dimens.radiusXSmall)
                            })
                            .disabledOverlay(!viewModel.state.isValidEmail || viewModel.state.password.isEmpty)
                            .skeleton(viewModel.state.isSigningIn)
                        }
                    }
                    .padding(Constants.Dimens.spaceLarge)
                }
                .background(.white)
                .cornerRadius(Constants.Dimens.radiusXSmall)
                .padding(.horizontal, Constants.Dimens.spaceLarge)
                
                if !viewModel.state.isSigningIn {
                    Button(action: {
                        viewModel.onIntent(.registerUser)
                    }, label: {
                        Text(L.Onboarding.finalizeRegistration)
                            .font(.callout)
                            .foregroundStyle(.white)
                            .underline()
                    })
                }
            }
            .padding(.horizontal, Constants.Dimens.spaceLarge)
        }
        .animation(.default, value: viewModel.state)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SignInView(viewModel: .init(flowController: nil))
}
