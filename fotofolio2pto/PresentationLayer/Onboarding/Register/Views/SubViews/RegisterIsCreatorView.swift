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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Typ profilu")
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
            
            Text(isCreator ? "Tvůrce 📸" : "Zákazník")
                .font(.title2)
                .foregroundColor(.black)
                .bold()
            
            Divider()
            
            HStack {
                Text(isCreator ? "Sky is the limit! 🌟" : "Staň se tvůrcem! 📸")
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                    .bold()
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundStyle(.green)
                
                Toggle("", isOn: $isCreator)
                    .labelsHidden()
            }
            
            Text("Tvůrci mohou vytvářet portfolia a prezentovat svou práci.")
                .font(.body)
            
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
        .animation(.default, value: isCreator)
    }
}
