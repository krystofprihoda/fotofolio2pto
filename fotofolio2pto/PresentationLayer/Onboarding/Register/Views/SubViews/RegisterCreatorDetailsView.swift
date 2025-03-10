//
//  RegisterCreatorDetailsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 10.03.2025.
//

import SwiftUI

struct RegisterCreatorDetailsView: View {
    let isCreator: Bool
    let onBackTap: () -> Void
    let onNextTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
            Text("Roky zkušeností ve fotografii")
                .font(.title3)
                .foregroundColor(.black)
                .bold()
            
            HorizontalWheelPicker()
                .padding(.vertical)
            
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
                    Text(isCreator ? L.Onboarding.next : L.Onboarding.finalizeRegistration)
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
    }
}
