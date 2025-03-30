//
//  PortfolioAuthorDetailView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct PortfolioAuthorDetailView: View {
    
    @ObservedObject private var viewModel: PortfolioAuthorDetailViewModel
    
    init(viewModel: PortfolioAuthorDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: viewModel.showProfile) {
                    Text("@\(viewModel.state.userData?.username ?? L.Selection.username)")
                        .font(.title3)
                        .padding(.leading, 20)
                        .foregroundColor(.mainAccent)
                }
                
                Spacer()
                
                Button(action: viewModel.sendMessage) {
                    Text(L.Selection.typeMessage)
                        .foregroundColor(.gray)
                }
                
                Button(action: viewModel.unflagPortfolio) {
                    Image(systemName: "bookmark.slash")
                        .foregroundColor(.black)
                }
                .padding(.trailing, 20)
            }
            .padding(.bottom, 1)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(viewModel.state.userData?.fullName ?? L.Selection.fullName)")
                        .foregroundColor(.black).brightness(0.3)
                        .font(.system(size: 16))
                    
                    if let userData = viewModel.state.userData {
                        if userData.rating.isEmpty {
                            Text("\(userData.location), \(L.Selection.noRating)")
                                .font(.system(size: 12))
                                .foregroundColor(.black).brightness(0.3)
                        } else {
                            HStack {
                                Text("\(userData.location), " + String(format: "%.1f", userData.averageRating) + L.Selection.outOf5)
                                    .font(.system(size: 12))
                                    .foregroundColor(.black).brightness(0.3)
                                
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.black).brightness(0.3)
                                    .offset(x: -5)
                            }
                        }
                    }
                }
                .padding(.leading, 25)
                
                Spacer()
            }
            
            HStack {
                Text(viewModel.state.creatorData?.profileText ?? L.Selection.profileText)
                    .font(.system(size: 16))
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
                Spacer()
            }
            .padding(.top, 5)
            .padding(.leading, 21)
            .padding(.trailing, 21)
        }
        .skeleton(viewModel.state.isLoading)
    }
}

//#Preview {
//    AuthorDetailView(author: .dummy1, creator: .dummy1, unflagPortfolio: {}, showProfile: {}, sendMessage: {})
//}
