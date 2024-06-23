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
                    if viewModel.state.isLoadingUser || viewModel.state.isLoadingPortfolios {
                        ProgressView()
                            .padding()
                            .frame(width: geo.size.width, height: geo.size.height)
                    } else {
                        ProfileUserInfoView(user: viewModel.state.userData, profileOwner: viewModel.state.userData?.username == viewModel.state.signedInUser)
                            .padding(.top)
                        
                        if viewModel.state.userData?.creator != nil {
                            ProfilePortfoliosView(portfolios: viewModel.state.portfolios)
                        } else {
                            NotCreatorView()
                        }
                    }
                }
            }
        }
        .setupNavBarAndTitle("@\(viewModel.state.userData?.username ?? "")")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if viewModel.state.userData?.username == viewModel.state.signedInUser && viewModel.state.userData?.creator != nil {
                    Button(action: {
                        // NewPortfolioView()
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: 15)
                            .foregroundColor(.gray)
                    }
                }
                
                HStack {
                    if viewModel.state.userData?.username == viewModel.state.signedInUser {
                        Menu(content: {
                            Button(action: {
                                // // EditProfileView()
                            }) {
                                Text("Upravit profil")
                                    .foregroundColor(.gray)
                            }
                            
                            Button(action: {
                                // Sign out delegate
                            }, label: {
                                Text("Odhlásit se")
                            })
                        }, label: {
                            Image(systemName: "slider.horizontal.3")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(height: 15)
                                .foregroundColor(.gray)
                        })
                    } else {
                        Button(action: {
                            // ChatView(receiver: user)
                        }, label: {
                            Image(systemName: "paperplane")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(height: 18)
                                .foregroundColor(.gray)
                        })
                    }
                }
                .padding(.leading, -15)
                .padding(.trailing, 5)
            }
        }
        .lifecycle(viewModel)
    }
}

#Preview {
    ProfileView(viewModel: .init(flowController: nil))
}
