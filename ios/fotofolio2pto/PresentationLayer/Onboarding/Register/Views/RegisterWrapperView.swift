//
//  RegisterWrapperView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 06.03.2025.
//

import SwiftUI

////  Gradient inspired by: https://github.com/flawless-code/swiftui-animations/blob/main/SwiftUIAnimations/SwiftUIAnimations/GradientBackgroundAnimation.swift

struct RegisterWrapperView<Content: View>: View {
    
    private let gradientDegrees: Double = 30
    private let duration: Double = 3
    @State private var animateGradient: Bool = false
    
    private let dismissRegistrationIsShowing: Bool
    private let onDismissRegistrationTap: () -> Void
    private let hideTitle: Bool
    private let content: Content
    
    init(
        dismissRegistrationIsShowing: Bool = true,
        onDismissRegistrationTap: @escaping () -> Void,
        hideTitle: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.dismissRegistrationIsShowing = dismissRegistrationIsShowing
        self.onDismissRegistrationTap = onDismissRegistrationTap
        self.hideTitle = hideTitle
        self.content = content()
    }
    var body: some View {
        ZStack(alignment: .center) {
            SignInBackgroundView()
            
            VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
                if !hideTitle {
                    Text(L.Onboarding.register)
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                        .padding(.leading, Constants.Dimens.spaceXXLarge)
                }
                
                VStack {
                    content
                        .padding(Constants.Dimens.spaceLarge)
                }
                .background(.white)
                .cornerRadius(Constants.Dimens.radiusXSmall)
                .padding(Constants.Dimens.spaceLarge)
                
                if dismissRegistrationIsShowing {
                    Button(action: onDismissRegistrationTap, label: {
                        Text(L.Onboarding.goBackToSignIn)
                            .font(.body)
                            .frame(height: Constants.Dimens.textFieldHeight/2)
                            .frame(maxWidth: .infinity)
                            .padding(Constants.Dimens.spaceLarge)
                            .foregroundStyle(.white)
                            .background(.mainLight)
                            .cornerRadius(Constants.Dimens.radiusXSmall)
                            .padding(.horizontal, Constants.Dimens.spaceXXLarge)
                    })
                }
            }
        }
        .animation(.default, value: hideTitle)
        .animation(.default, value: dismissRegistrationIsShowing)
    }
}
