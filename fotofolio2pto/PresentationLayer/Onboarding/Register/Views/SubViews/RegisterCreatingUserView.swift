//
//  RegisterCreatingUserView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 11.03.2025.
//

import SwiftUI

struct RegisterCreatingUserView: View {
    private let userCreated: Bool
    
    public init(userCreated: Bool) {
        self.userCreated = userCreated
    }
    
    var body: some View {
        ZStack {
            PulsingCircleView()
            
            if userCreated {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: Constants.Dimens.frameSizeSmall, height: Constants.Dimens.frameSizeSmall)
                    .foregroundStyle(.white)
                    .animation(.spring, value: userCreated)
            }
        }
        .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
    }
}
