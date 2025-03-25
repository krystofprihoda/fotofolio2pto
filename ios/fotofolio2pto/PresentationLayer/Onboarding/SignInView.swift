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
                FotofolioAnimatedLogo()
                
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
                                password: Binding(get: { viewModel.state.password }, set: { viewModel.onIntent(.setPassword($0)) })
                            )
                            
                            Button(action: { viewModel.onIntent(.signIn) }, label: {
                                Text(L.Onboarding.signInAction)
                                    .font(.body)
                                    .frame(height: Constants.Dimens.textFieldHeight)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundStyle(.white)
                                    .background(.mainAccent)
                                    .cornerRadius(Constants.Dimens.radiusXSmall)
                            })
                            .disabledOverlay(viewModel.state.email.isEmpty || viewModel.state.password.isEmpty)
                            .skeleton(viewModel.state.isSigningIn)
                        }
                    }
                    .padding()
                }
                .background(.white)
                .cornerRadius(Constants.Dimens.radiusXSmall)
                .padding(.horizontal)
                
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
            .padding(.horizontal)
        }
        .animation(.default, value: viewModel.state)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SignInView(viewModel: .init(flowController: nil))
}

struct FotofolioAnimatedLogo: View {
    @State private var scaleFirst: CGFloat = 1.0
    @State private var scaleSecond: CGFloat = 1.0
    @State private var scaleThird: CGFloat = 1.0
    
    private let coef = 1.15
    private let duration = 7.0
    private let resize = 1.35
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .stroke(lineWidth: Constants.Dimens.lineWidthXSmall)
                    .frame(width: Constants.Dimens.frameSizeLarge, height: Constants.Dimens.frameSizeLarge)
                    .opacity(Constants.Dimens.opacityHigh)
                    .scaleEffect(scaleFirst)
                
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .stroke(lineWidth: Constants.Dimens.lineWidthXSmall)
                    .frame(width: Constants.Dimens.frameSizeXLarge, height: Constants.Dimens.frameSizeXLarge)
                    .opacity(Constants.Dimens.opacityMid)
                    .scaleEffect(scaleSecond)
                
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .stroke(lineWidth: Constants.Dimens.lineWidthXSmall)
                    .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                    .opacity(Constants.Dimens.opacityLow)
                    .scaleEffect(scaleThird)
            }
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: scaleFirst
            )
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: scaleSecond
            )
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: scaleThird
            )
            .onAppear {
                scaleFirst = resize
                scaleSecond = resize * coef
                scaleThird = resize * coef * coef
            }
            .foregroundColor(.white)
            .offset(y: Constants.Dimens.spaceXSmall)
            
            Image("fotofolio_text_dark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
        }
    }
}
