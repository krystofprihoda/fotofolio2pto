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
                
                // description
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .fill(.textFieldBackground)
                        .frame(height: Constants.Dimens.frameSizeXXLarge)
                        
                    TextEditor(
                        text: Binding(
                            get: { viewModel.state.profileDescription },
                            set: { viewModel.onIntent(.setProfileDescription($0)) }
                        )
                    )
                        .font(.body)
                        .frame(height: Constants.Dimens.frameSizeXXLarge)
                        .lineSpacing(Constants.Dimens.spaceXSmall)
                        .foregroundColor(.gray)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .offset(
                            x: Constants.Dimens.spaceSmall,
                            y: Constants.Dimens.spaceXSmall
                        )
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    EditCreatorDetailsView(viewModel: .init(flowController: nil, userData: .dummy1, portfolios: []))
}
