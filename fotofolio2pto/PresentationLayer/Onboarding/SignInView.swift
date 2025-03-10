//
//  SignInView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct SignInView: View {
    
    private let gradientDegrees: Double = 30
    private let duration: Double = 1.5
    @State private var animateGradient: Bool = false
    
    @ObservedObject private var viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("sydney_opera_house")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(contentMode: .fill)
            
            LinearGradient(colors: [.white, .mainAccent], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .hueRotation(.degrees(animateGradient ? gradientDegrees : 0))
                .onAppear {
                    withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
                .opacity(0.9)
            
            VStack(spacing: Constants.Dimens.spaceLarge) {
                //Logo
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                            .stroke(lineWidth: Constants.Dimens.lineWidthXSmall)
                            .frame(width: 100, height: 100)
                            .opacity(0.9)
                        
                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                            .stroke(lineWidth: Constants.Dimens.lineWidthXSmall)
                            .frame(width: 150, height: 150)
                            .opacity(0.6)
                        
                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                            .stroke(lineWidth: Constants.Dimens.lineWidthXSmall)
                            .frame(width: 200, height: 200)
                            .opacity(0.3)
                    }
                    .foregroundColor(.white)
                    .offset(y: Constants.Dimens.spaceXSmall)
                    
                    Image("fotofolio_text_dark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)
                }
                
                Text(L.Onboarding.signIn)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, Constants.Dimens.spaceNone)
                
                VStack {
                    VStack(spacing: Constants.Dimens.spaceLarge) {
                        LoginCredentialsView(
                            username: Binding(get: { viewModel.state.username }, set: { viewModel.onIntent(.setUsername($0)) }),
                            password: Binding(get: { viewModel.state.password }, set: { viewModel.onIntent(.setPassword($0)) }),
                            fillUsernameAlert: .constant(false),
                            passwordAlert: .constant(false)
                        )
                        
                        if !viewModel.state.error.isEmpty {
                            Text(viewModel.state.error)
                                .foregroundColor(.red)
                                .font(.system(size: 13))
                                .padding(.top)
                        }
                        
                        Button(action: {
                            viewModel.onIntent(.signIn)
                        }, label: {
                            Text(L.Onboarding.signInAction)
                                .font(.body)
                                .frame(height: Constants.Dimens.textFieldHeight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.mainAccent)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                        .skeleton(viewModel.state.isSigningIn)
                    }
                    .padding()
                }
                .background(.white)
                .cornerRadius(Constants.Dimens.radiusXSmall)
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.onIntent(.registerUser)
                }, label: {
                    Text(L.Onboarding.finalizeRegistration)
                        .font(.callout)
                        .foregroundStyle(.white)
                        .underline()
                })
            }
            .padding()
        }
        .ignoresSafeArea(.all)
        .setupNavBarAndTitle("")
    }
}

#Preview {
    SignInView(viewModel: .init(flowController: nil))
}
