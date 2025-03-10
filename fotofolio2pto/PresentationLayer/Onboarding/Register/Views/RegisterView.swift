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
            onDismissRegistrationTap: { viewModel.onIntent(.dismissRegistration) }
        ) {
            switch viewModel.state.stage {
            case .nameAndEmail:
                RegisterNameAndEmailView(
                    name: Binding(
                        get: { viewModel.state.name },
                        set: { viewModel.onIntent(.onNameChanged($0)) }
                    ),
                    email: Binding(
                        get: { viewModel.state.email },
                        set: { viewModel.onIntent(.onEmailInput($0)) }
                    ),
                    emailError: viewModel.state.emailError,
                    emailVerified: viewModel.state.emailVerified,
                    showSkeleton: viewModel.state.showSkeleton,
                    onEmailChanged: { viewModel.onIntent(.onEmailChanged) },
                    onNextTap: { viewModel.onIntent(.onNameAndEmailNextTap) }
                )
            case .username:
                RegisterUsernameView(
                    username: Binding(
                        get: { viewModel.state.username },
                        set: { viewModel.onIntent(.onUsernameInput($0)) }
                    ),
                    usernameError: viewModel.state.usernameError,
                    usernameVerified: viewModel.state.usernameVerified,
                    showSkeleton: viewModel.state.showSkeleton,
                    onUsernameChanged: { viewModel.onIntent(.onUsernameChanged) },
                    onBackTap: { viewModel.onIntent(.goBack(to: .nameAndEmail)) },
                    onNextTap: { viewModel.onIntent(.onUsernameNextTap) }
                )
            case .password:
                RegisterPasswordView(
                   firstPassword: Binding(
                       get: { viewModel.state.firstPassword },
                       set: { viewModel.onIntent(.setPassword(isFirst: true, $0)) }
                   ),
                   firstPasswordError: viewModel.state.firstPasswordError,
                   isFirstPasswordHidden: viewModel.state.isFirstPasswordHidden,
                   onToggleFirstPasswordVisibility: { viewModel.onIntent(.onPasswordToggleVisibility(isFirst: true)) },
                   secondPassword: Binding(
                       get: { viewModel.state.secondPassword },
                       set: { viewModel.onIntent(.setPassword(isFirst: false, $0)) }
                   ),
                   secondPasswordError: viewModel.state.secondPasswordError,
                   isSecondPasswordHidden: viewModel.state.isSecondPasswordHidden,
                   onToggleSecondPasswordVisibility: { viewModel.onIntent(.onPasswordToggleVisibility(isFirst: false)) },
                   passwordsVerified: viewModel.state.passwordsVerified,
                   showSkeleton: viewModel.state.showSkeleton,
                   onFirstPasswordChanged: { viewModel.onIntent(.onPasswordChanged(isFirst: true)) },
                   onSecondPasswordChanged: { viewModel.onIntent(.onPasswordChanged(isFirst: false)) },
                   onBackTap: { viewModel.onIntent(.goBack(to: .username)) },
                   onNextTap: { viewModel.onIntent(.onPasswordNextTap) }
               )
            case .isCreator:
                Text("isCreator")
            case .creatorDetails:
                Text("Creator Details")
            case .done:
                Text("All done")
            }
        }
        .animation(.default, value: viewModel.state.stage)
    }
}
