//
//  RegisterFailedView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 11.03.2025.
//

import SwiftUI

struct RegisterFailedView: View {
    private let onTryAgain: () -> Void
    
    public init(onTryAgain: @escaping () -> Void) {
        self.onTryAgain = onTryAgain
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: Constants.Dimens.spaceNone) {
            ZStack {
                PulsingCircleView()
                
                VStack(alignment: .center) {
                    Image(systemName: "exclamationmark.icloud.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.Dimens.frameSizeSmall, height: Constants.Dimens.frameSizeSmall)
                        .foregroundStyle(.white)
                    
                    Text(L.General.somethingWentWrong)
                        .font(.body)
                        .bold()
                        .foregroundStyle(.white)
                }
            }
            
            Button(action: onTryAgain, label: {
                BaseButton(L.Onboarding.tryAgain)
            })
        }
    }
}
