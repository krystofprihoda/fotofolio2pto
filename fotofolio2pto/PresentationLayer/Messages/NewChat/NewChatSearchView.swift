//
//  NewChatSearchView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import SwiftUI

struct NewChatSearchView: View {
    
    @ObservedObject private var viewModel: NewChatSearchViewModel
    
    init(viewModel: NewChatSearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            // Search
            ZStack {
                Rectangle()
                    .foregroundColor(.textFieldBackground)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField(L.Messages.search, text: Binding(get: { viewModel.state.textInput }, set: { viewModel.onIntent(.setTextInput($0)) }))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: viewModel.state.textInput) { _ in
                            viewModel.onIntent(.search)
                        }
                }
                .padding()
             }
            .frame(height: Constants.Dimens.frameSizeSmall)
            .cornerRadius(Constants.Dimens.radiusXSmall)
            .padding([.leading, .trailing])
            
            // Results
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.state.searchResults) { user in
                    Button(action: { viewModel.onIntent(.showNewChatWithUser(user)) }) {
                        HStack {
                            ProfilePictureView(profilePicture: user.profilePicture)
                                .padding(.leading, Constants.Dimens.spaceSemiLarge)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(user.username)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .padding(.bottom, Constants.Dimens.spaceXSmall)
                                
                                Text(user.location)
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                    .padding(.bottom, Constants.Dimens.spaceXXSmall)
                            }
                            .padding(.leading, Constants.Dimens.spaceSmall)
                            
                            Spacer()
                        }
                        .padding(.top, Constants.Dimens.spaceMedium)
                        .transition(.move(edge: .trailing))
                    }
                }
            }
        }
        .padding(.top)
        .setupNavBarAndTitle(L.Messages.newChat)
    }
}

#Preview {
    NewChatSearchView(viewModel: .init(flowController: nil, sender: ""))
}
