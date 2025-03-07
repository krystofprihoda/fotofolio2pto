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
        let showDismiss = viewModel.state.stage == .nameAndEmail
        RegisterWrapperView(
            dismissRegistrationIsShowing: showDismiss,
            onDismissRegistrationTap: { viewModel.onIntent(.goBackToSignIn) }
        ) {
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
                            .font(.body)
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
                        Button(action: { viewModel.onIntent(.goBackToNameAndEmail) }, label: {
                            Text("Zpět")
                                .font(.body)
                                .frame(height: Constants.Dimens.textFieldHeight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.mainAccent)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                        
                        Button(action: { }, label: {
                            Text("Další")
                                .font(.body)
                                .frame(height: Constants.Dimens.textFieldHeight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.mainAccent)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                        .skeleton(viewModel.state.showSkeleton)
                    }
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
        .animation(.default, value: viewModel.state.stage)
    }
}
