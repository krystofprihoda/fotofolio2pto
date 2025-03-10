//
//  RegisterUsernameView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 10.03.2025.
//

import SwiftUI

struct RegisterUsernameView: View {
    var username: Binding<String>
    var usernameError: String
    var usernameVerified: Bool
    var showSkeleton: Bool
    var onUsernameChanged: () -> Void
    var onBackTap: () -> Void
    var onNextTap: () -> Void
    
    var body: some View {
        VStack {
            TextField(L.Onboarding.usernameEng, text: username)
                .font(.body)
                .frame(height: Constants.Dimens.textFieldHeight)
                .padding()
                .background(.textFieldBackground)
                .cornerRadius(Constants.Dimens.radiusXSmall)
                .disableAutocorrection(true)
                .onChange(of: username.wrappedValue) { _ in
                    onUsernameChanged()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .stroke(.mainAccent, lineWidth: 1)
                        .opacity(usernameError.isEmpty ? 0 : 1)
                )
            
            if !usernameError.isEmpty {
                Text(usernameError)
                    .font(.footnote)
                    .foregroundColor(.mainAccent)
            }
            
            HStack {
                Button(action: onBackTap, label: {
                    Text(L.Onboarding.goBack)
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.mainAccent)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                })
                
                Button(action: onNextTap, label: {
                    Text(L.Onboarding.next)
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.mainAccent)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                })
                .disabled(!usernameVerified)
                .skeleton(showSkeleton)
            }
        }
        .animation(.default, value: usernameError)
    }
}
