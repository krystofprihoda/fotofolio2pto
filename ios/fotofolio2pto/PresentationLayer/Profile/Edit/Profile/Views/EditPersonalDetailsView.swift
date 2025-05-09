//
//  EditPersonalDetailsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct EditPersonalDetailsView: View {
    
    @ObservedObject var viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Dimens.spaceMedium) {
            HStack(spacing: Constants.Dimens.spaceSmall) {
                ZStack {
                    ProfilePictureView(
                        profilePicture: viewModel.state.profilePicture,
                        width: Constants.Dimens.frameSizeSmallMedium
                    )
                    
                    Button(action: { viewModel.onIntent(.pickProfilePicture) }) {
                        ZStack {
                            Circle()
                                .fill(.mainText)
                                .frame(
                                    width: Constants.Dimens.frameSizeSmallMedium,
                                    height: Constants.Dimens.frameSizeSmallMedium
                                )
                                .opacity(Constants.Dimens.opacityMid)
                            
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: Constants.Dimens.spaceXXSmall) {
                    Text(viewModel.state.username)
                        .font(.body)
                        .foregroundColor(.main)
                    
                    Text(viewModel.state.fullName)
                        .font(.body)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: Constants.Dimens.spaceXSmall) {
                Text(L.Profile.activePlace)
                    .font(.footnote)
                    .foregroundColor(.black)
                
                TextFieldView(
                    title: L.Profile.activePlace,
                    text: Binding(
                        get: { viewModel.state.updatedLocation },
                        set: { viewModel.onIntent(.setLocation($0)) })
                )
            }
        }
        .padding([.horizontal, .top], Constants.Dimens.spaceLarge)
    }
}

#Preview {
    EditPersonalDetailsView(viewModel: .init(flowController: nil, userData: .dummy1))
}
