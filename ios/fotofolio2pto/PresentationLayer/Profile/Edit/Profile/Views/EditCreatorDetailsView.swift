//
//  EditCreatorDetailsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct EditCreatorDetailsView: View {
    
    @ObservedObject var viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text(L.Profile.yearsOfExperience)
                    .font(.footnote)
                    .foregroundColor(.black)
                
                HorizontalWheelPicker(
                    selectedValue: Binding(
                        get: { viewModel.state.yearsOfExperience },
                        set: { viewModel.onIntent(.setYearsOfExperience($0)) }
                    )
                )
            }
            
            VStack(alignment: .leading) {
                Text(L.Profile.description)
                    .font(.footnote)
                    .foregroundColor(.black)
                
                BaseTextEditor(
                    text: Binding(
                        get: { viewModel.state.profileDescription },
                        set: { viewModel.onIntent(.setProfileDescription($0)) }
                    )
                )
                .frame(height: Constants.Dimens.frameSizeXLarge)
            }
        }
        .padding(.horizontal, Constants.Dimens.spaceLarge)
    }
}

#Preview {
    EditCreatorDetailsView(viewModel: .init(flowController: nil, userData: .dummy1))
}
