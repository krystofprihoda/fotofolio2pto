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
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    ProfilePictureView(profilePicture: viewModel.state.userData?.profilePicture)
                    
                    Button(action: { viewModel.onIntent(.pickProfilePicture) }) {
                        ZStack {
                            Circle()
                                .fill(.gray)
                                .frame(width: 40, height: 40)
                                .opacity(0.75)
                            
                            Image(systemName: "pencil")
                                .foregroundColor(.gray)
                                .brightness(0.37)
                        }
                    }
                }
                .padding(.leading, 20)
                
                VStack(alignment: .leading) {
                    Text("@" + (viewModel.state.userData?.username ?? L.Profile.usernameError))
                        .font(.body)
                        .foregroundColor(.red).brightness(0.2)
                        .padding(.leading, 20)
                    
                    Text(viewModel.state.userData?.fullName ?? L.Profile.nameError)
                        .font(.body)
                        .foregroundColor(.black).brightness(0.2)
                        .padding(.bottom, 4)
                        .padding(.leading, 20)
                }
                
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            
            VStack(alignment: .leading) {
                Text(L.Profile.activePlace)
                    .font(.system(size: 16))
                    .foregroundColor(.black).brightness(0.25)
                    .padding(.leading, 20)
                    .padding(.bottom, -1)
                
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .foregroundColor(.gray).brightness(0.42)
                        .frame(height: 45)
                        .offset(x: -5)
                    
                    TextEditor(text: Binding(get: { viewModel.state.userData!.location }, set: { _ in }))
                        .lineSpacing(1)
                        .frame(height: 38)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 16)
                
                Spacer()
            }
        }
    }
}

#Preview {
    EditPersonalDetailsView(viewModel: .init(flowController: nil, userData: .dummy1, portfolios: [.dummyPortfolio1]))
}
