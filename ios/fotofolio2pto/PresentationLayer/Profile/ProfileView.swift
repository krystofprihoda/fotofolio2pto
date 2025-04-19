//
//  ProfileView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack {
                    if viewModel.state.isLoading {
                        ProgressView()
                            .padding(Constants.Dimens.spaceLarge)
                            .frame(width: geo.size.width, height: geo.size.height)
                    } else {
                        ProfileUserInfoView(
                            user: viewModel.state.userData,
                            creator: viewModel.state.creatorData,
                            profileOwner: viewModel.state.isProfileOwner,
                            onGiveRatingTap: { viewModel.onIntent(.giveRating) }
                        )
                            .padding(.top, Constants.Dimens.spaceSmall)
                        if viewModel.state.creatorData != nil {
                            ProfilePortfoliosView(portfolios: viewModel.state.portfolios)
                        } else {
                            NotCreatorView()
                        }
                    }
                }
                .skeleton(viewModel.state.isRefreshing)
            }
            .refreshable { viewModel.onIntent(.fetchProfileData(isRefreshing: true)) }
        }
        .toast(toastData: Binding(get: { viewModel.state.toastData }, set: { viewModel.onIntent(.setToastData($0)) }))
        .navigationBarItems(leading: backButton, trailing: trailingButtons)
        .setupNavBarAndTitle(viewModel.state.userData?.username ?? "", hideBack: true)
        .lifecycle(viewModel)
    }
    
    var backButton: some View {
        Button(L.General.back) {
            viewModel.onIntent(.goBack)
        }
        .disabled(!viewModel.state.showDismiss)
        .opacity(viewModel.state.showDismiss ? 1 : 0)
    }
    
    var trailingButtons: some View {
        HStack(spacing: Constants.Dimens.spaceXSmall) {
            if viewModel.state.isProfileOwner, viewModel.state.creatorData != nil {
                Button(action: {
                    viewModel.onIntent(.createNewPortfolio)
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: Constants.Dimens.frameSizeXSmall)
                        .foregroundColor(.mainText)
                }
            }
            
            if viewModel.state.isProfileOwner {
                Button(action: {
                    viewModel.onIntent(.showProfileSettings)
                }, label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: Constants.Dimens.frameSizeXSmall)
                        .foregroundColor(.mainText)
                })
            } else {
                Button(action: {
                    viewModel.onIntent(.sendMessage)
                }, label: {
                    Image(systemName: "paperplane")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: Constants.Dimens.frameSizeXSmall)
                        .foregroundColor(.mainText)
                })
            }
        }
    }
}

#Preview {
    ProfileView(viewModel: .init(flowController: nil, signedInUserId: "", displayedUserId: ""))
}
