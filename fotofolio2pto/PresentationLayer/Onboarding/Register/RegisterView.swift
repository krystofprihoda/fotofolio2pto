//
//  RegisterView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 04.03.2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject private var viewModel: RegisterViewModel
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        RegisterWrapperView {
            switch viewModel.state.stage {
            case .nameAndEmail:
                VStack {
                    TextField("Jméno", text: Binding(get: { viewModel.state.name }, set: { viewModel.onIntent(.onNameChanged($0)) }))
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .padding()
                        .background(.textFieldBackground)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        .disableAutocorrection(true)
                    
                    TextField("Email", text: Binding(get: { viewModel.state.email }, set: { viewModel.onIntent(.onEmailInput($0)) }))
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .padding()
                        .background(.textFieldBackground)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: viewModel.state.email) { _ in
                            viewModel.onIntent(.onEmailChanged)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                .stroke(.mainAccent, lineWidth: 1)
                                .opacity(viewModel.state.emailError.isEmpty ? 0 : 1)
                        )
                    
                    if !viewModel.state.emailError.isEmpty {
                        Text(viewModel.state.emailError)
                            .font(.system(size: 14))
                            .foregroundColor(.mainAccent)
                    }
                    
                    Button(action: { viewModel.onIntent(.onNameAndEmailNextTap)}, label: {
                        Text("Další")
                            .frame(height: Constants.Dimens.textFieldHeight)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.mainAccent)
                            .cornerRadius(Constants.Dimens.radiusXSmall)
                    })
                    .disabled(!viewModel.state.emailVerified)
                    .skeleton(viewModel.state.showSkeleton)
                }
                .animation(.default, value: viewModel.state.emailError)
            case .username:
                VStack {
                    TextField("Username", text: Binding(get: { "" }, set: { _ in }))
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .padding()
                        .background(.textFieldBackground)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        .disableAutocorrection(true)
                    
                    if !viewModel.state.emailError.isEmpty {
                        Text(viewModel.state.emailError)
                            .font(.system(size: 14))
                            .foregroundColor(.mainAccent)
                    }
                    
                    HStack {
                        Button(action: { }, label: {
                            Text("Zpět")
                                .frame(height: Constants.Dimens.textFieldHeight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.mainAccent)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                        
                        Button(action: { }, label: {
                            Text("Další")
                                .frame(height: Constants.Dimens.textFieldHeight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.mainAccent)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                    }
                    .disabled(true)
                    .skeleton(viewModel.state.showSkeleton)
                }
                .animation(.default, value: viewModel.state.usernameError)
            case .password:
                EmptyView()
            case .location:
                EmptyView()
            case .profilePicture:
                EmptyView()
            case .isCreator:
                EmptyView()
            case .creatorDetails:
                EmptyView()
            case .done:
                EmptyView()
            }
        }
    }
}

struct RegisterWrapperView<Content: View>: View {
    
    private let gradientDegrees: Double = 30
    private let duration: Double = 3
    @State private var animateGradient: Bool = false
    
    private let content: Content
    
    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }
    var body: some View {
        ZStack(alignment: .center) {
            LinearGradient(colors: [.mainAccent, .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .hueRotation(.degrees(animateGradient ? gradientDegrees : 0))
                .onAppear {
                    withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            
            VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
                Text("Registrace.")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                    .padding(.leading)
                    .padding(.leading)
                
                VStack {
                    content
                        .padding()
                }
                .background(.white)
                .cornerRadius(Constants.Dimens.radiusXSmall)
                .padding()
            }
        }
        .ignoresSafeArea(.all)
    }
}
