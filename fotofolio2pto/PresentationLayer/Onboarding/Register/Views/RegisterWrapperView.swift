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
    private let content: Content
    
    init(
        dismissRegistrationIsShowing: Bool = true,
        onDismissRegistrationTap: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.dismissRegistrationIsShowing = dismissRegistrationIsShowing
        self.onDismissRegistrationTap = onDismissRegistrationTap
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
                
                if dismissRegistrationIsShowing {
                    Button(action: onDismissRegistrationTap, label: {
                        Text("Zpět na přihlášení")
                            .font(.body)
                            .frame(height: Constants.Dimens.textFieldHeight/2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.mainAccent)
                            .cornerRadius(Constants.Dimens.radiusXSmall)
                            .padding(.horizontal)
                            .padding(.horizontal)
                    })
                }
            }
        }
        .ignoresSafeArea(.all)
    }
}
