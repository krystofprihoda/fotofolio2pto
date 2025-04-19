//
//  RegisterIsCreatorView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 10.03.2025.
//

import SwiftUI

struct RegisterIsCreatorView: View {
    @Binding var isCreator: Bool
    let onBackTap: () -> Void
    let onNextTap: () -> Void
    
    @State private var animatedArrowPadding = Constants.Dimens.spaceMedium
    private let animationDuration = 1.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(L.Onboarding.profileType)
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
            
            Text(isCreator ? L.Onboarding.typeCreator : L.Onboarding.typeCustomer)
                .font(.title2)
                .foregroundColor(.black)
                .bold()
            
            Divider()
            
            HStack(spacing: Constants.Dimens.spaceNone) {
                Text(isCreator ? L.Onboarding.skyIsTheLimit : L.Onboarding.becomeACreator)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                    .bold()
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundStyle(.green)
                    .padding(animatedArrowPadding)
                    .animation(
                        .easeInOut(duration: animationDuration)
                        .repeatForever(autoreverses: true),
                        value: animatedArrowPadding
                    )
                    .onAppear {
                        animatedArrowPadding = Constants.Dimens.spaceXSmall
                    }
                
                Toggle("", isOn: $isCreator)
                    .labelsHidden()
            }
            
            Text(L.Onboarding.creatorDescription)
                .font(.body)
            
            HStack {
                Button(action: onBackTap, label: {
                    Text(L.General.back)
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .frame(maxWidth: .infinity)
                        .padding(Constants.Dimens.spaceLarge)
                        .foregroundStyle(.white)
                        .background(.mainLight)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                })
                
                Button(action: onNextTap, label: {
                    Text(isCreator ? L.Onboarding.next : L.Onboarding.finalizeRegistration)
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .frame(maxWidth: .infinity)
                        .padding(Constants.Dimens.spaceLarge)
                        .foregroundStyle(.white)
                        .background(.mainLight)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                })
            }
        }
        .animation(.default, value: isCreator)
    }
}
