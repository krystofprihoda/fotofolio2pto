//
//  RegisterCreatorDetailsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 10.03.2025.
//

import SwiftUI

struct RegisterCreatorDetailsView: View {
    @Binding private var yearsOfExperience: Int
    private let isCreator: Bool
    private let onBackTap: () -> Void
    private let onNextTap: () -> Void
    
    init(
        yearsOfExperience: Binding<Int>,
        isCreator: Bool,
        onBackTap: @escaping () -> Void,
        onNextTap: @escaping () -> Void
    ) {
        self._yearsOfExperience = yearsOfExperience
        self.isCreator = isCreator
        self.onBackTap = onBackTap
        self.onNextTap = onNextTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
            Text(L.Onboarding.yearsOfExperience)
                .font(.title3)
                .foregroundColor(.black)
                .bold()
            
            HorizontalWheelPicker(selectedValue: $yearsOfExperience)
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
