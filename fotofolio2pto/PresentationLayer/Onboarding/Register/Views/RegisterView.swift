//
//  RegisterView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 04.03.2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject private var viewModel: RegisterViewModel
    
    @State private var tmpValue: Int = 1
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let showDismiss = viewModel.state.stage == .nameAndEmail
        RegisterWrapperView(
            dismissRegistrationIsShowing: showDismiss,
            onDismissRegistrationTap: { viewModel.onIntent(.dismissRegistration) },
            hideTitle: viewModel.state.hideOnboardingTitle
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
                VStack(alignment: .leading) {
                    Text("Typ profilu")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                    
                    Text(viewModel.state.isCreator ? "Tvůrce 📸" : "Zákazník")
                        .font(.title2)
                        .foregroundColor(.black)
                        .bold()
                    
                    Divider()
                    
                    HStack {
                        Text(viewModel.state.isCreator ? "Sky is the limit! 🌟" : "Staň se tvůrcem! 📸")
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                            .bold()
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundStyle(.green)
                        
                        Toggle("", isOn: Binding(get: { viewModel.state.isCreator }, set: { viewModel.onIntent(.setIsCreator(to: $0))}))
                            .labelsHidden()
                    }
                    
                    Text("Tvůrci mohou vytvářet portfolia a prezentovat svou práci.")
                        .font(.body)
                    
                    HStack {
                        Button(action: { viewModel.onIntent(.goBack(to: .password)) }, label: {
                            Text(L.Onboarding.goBack)
                                .font(.body)
                                .frame(height: Constants.Dimens.textFieldHeight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.mainAccent)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                        
                        Button(action: { viewModel.onIntent(.onCreatorNextTap) }, label: {
                            Text(viewModel.state.isCreator ? L.Onboarding.next : L.Onboarding.finalizeRegistration)
                                .font(.body)
                                .frame(height: Constants.Dimens.textFieldHeight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.mainAccent)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                    }
                }
                .animation(.default, value: viewModel.state.isCreator)
            case .creatorDetails:
                VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
                    Text("Roky zkušeností ve fotografii")
                        .font(.title3)
                        .foregroundColor(.black)
                        .bold()
                    
                    HorizontalWheelPicker()
                        .padding(.vertical)
                    
                    HStack {
                        Button(action: { viewModel.onIntent(.goBack(to: .isCreator)) }, label: {
                            Text(L.Onboarding.goBack)
                                .font(.body)
                                .frame(height: Constants.Dimens.textFieldHeight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.mainAccent)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                        
                        Button(action: { viewModel.onIntent(.onCreatorDetailsNextTap) }, label: {
                            Text(viewModel.state.isCreator ? L.Onboarding.next : L.Onboarding.finalizeRegistration)
                                .font(.body)
                                .frame(height: Constants.Dimens.textFieldHeight)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.mainAccent)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                    }
                }
            case .done:
                ZStack {
                    PulsingCircleView()
                    
                    if viewModel.state.userCreated {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: Constants.Dimens.frameSizeSmall, height: Constants.Dimens.frameSizeSmall)
                            .foregroundStyle(.white)
                            .animation(.spring, value: viewModel.state.userCreated)
                    }
                }
                .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
            }
        }
        .animation(.default, value: viewModel.state)
    }
}

struct PulsingCircleView: View {
    @State private var scale: CGFloat = 1.0
    @State private var color: Color = .mainAccent
    
    private let duration = 1.0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: Constants.Dimens.frameSizeLarge, height: Constants.Dimens.frameSizeLarge)
            .scaleEffect(scale)
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: scale
            )
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: color
            )
            .onAppear {
                scale = 1.5
                color = .gray
            }
    }
}

struct CustomHorizontalWheelPicker: View {
    @State private var selectedValue: Int = 1
    private var lowestValue: Int = 0
    private var highestValue: Int = 60
    
    var body: some View {
        ScrollViewReader { proxy in
           ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: Constants.Dimens.spaceNone) {
                   ForEach(lowestValue...highestValue, id: \.self) { idx in
                       Text("\(idx)")
                           .font(.title3)
                           .foregroundColor(selectedValue == idx ? .white : .black)
                           .gesture(TapGesture().onEnded({
                               withAnimation(.linear) {
                                   proxy.scrollTo(idx, anchor: .center)
                                   selectedValue = idx
                               }
                           }))
                           .id(idx)
                           .padding(.horizontal)
                           .padding(.vertical, Constants.Dimens.spaceMedium)
                           .background(
                               RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                   .fill(idx == selectedValue ? .mainAccent : .clear)
                           )
                   }
               }
           }
           .onAppear {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   withAnimation(.spring(duration: 2)) {
                       proxy.scrollTo(selectedValue, anchor: .center)
                   }
               }

           }
       }
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding(.vertical)
       .background(.textFieldBackground)
       .clipShape(RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall))
    }
}

struct HorizontalWheelPicker: View {
    @State private var selectedValue: Int = 5
    let lowestValue = 0
    let highestValue = 100
    let blurThreshold = 3
    let animationDuration = 2.0
    let animationDelay = 0.5

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(lowestValue...highestValue, id: \.self) { idx in
                        Text("\(idx)")
                            .font(.title3)
                            .foregroundColor(selectedValue == idx ? .white : .black)
                            .gesture(TapGesture().onEnded {
                                withAnimation(.linear) {
                                    proxy.scrollTo(idx, anchor: .center)
                                    selectedValue = idx
                                }
                            })
                            .id(idx)
                            .padding(.horizontal)
                            .padding(.vertical, Constants.Dimens.spaceMedium)
                            .background(
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(idx == selectedValue ? Color.blue : Color.clear)
                            )
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                    withAnimation(.spring(duration: animationDuration)) {
                        proxy.scrollTo(selectedValue, anchor: .center)
                    }
                }
            }
        }
        .mask(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(selectedValue > lowestValue + blurThreshold ? 0 : 1),
                    Color.black.opacity(1),
                    Color.black.opacity(1),
                    Color.black.opacity(selectedValue < highestValue - blurThreshold ? 0 : 1)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}
