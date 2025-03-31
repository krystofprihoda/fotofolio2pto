//
//  PortfolioAuthorDetailView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct PortfolioAuthorDetailView: View {
    
    private let isLoading: Bool
    private let userData: User?
    private let creatorData: Creator?
    
    private let showProfile: () -> Void
    private let sendMessage: () -> Void
    private let unflagPortfolio: () -> Void
    
    public init(
        isLoading: Bool,
        userData: User?,
        creatorData: Creator?,
        showProfile: @escaping () -> Void,
        sendMessage: @escaping () -> Void,
        unflagPortfolio: @escaping () -> Void
    ) {
        self.isLoading = isLoading
        self.userData = userData
        self.creatorData = creatorData
        self.showProfile = showProfile
        self.sendMessage = sendMessage
        self.unflagPortfolio = unflagPortfolio
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: showProfile) {
                    Text("@\(userData?.username ?? L.Selection.username)")
                        .font(.title3)
                        .padding(.leading, 20)
                        .foregroundColor(.mainAccent)
                }
                
                Spacer()
                
                Button(action: sendMessage) {
                    Text(L.Selection.typeMessage)
                        .foregroundColor(.gray)
                }
                
                Button(action: unflagPortfolio) {
                    Image(systemName: "bookmark.slash")
                        .foregroundColor(.black)
                }
                .padding(.trailing, 20)
            }
            .padding(.bottom, 1)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(userData?.fullName ?? L.Selection.fullName)")
                        .foregroundColor(.black).brightness(0.3)
                        .font(.system(size: 16))
                    
                    if let userData = userData {
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
                Text(creatorData?.description ?? L.Selection.profileText)
                    .font(.system(size: 16))
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
                Spacer()
            }
            .padding(.top, 5)
            .padding(.leading, 21)
            .padding(.trailing, 21)
        }
        .skeleton(isLoading)
    }
}

//#Preview {
//    AuthorDetailView(author: .dummy1, creator: .dummy1, unflagPortfolio: {}, showProfile: {}, sendMessage: {})
//}
