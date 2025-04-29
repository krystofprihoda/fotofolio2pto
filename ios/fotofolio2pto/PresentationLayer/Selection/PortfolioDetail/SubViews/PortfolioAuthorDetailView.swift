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
                        .padding(.leading, Constants.Dimens.spaceSemiXLarge)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Button(action: sendMessage) {
                    Text(L.Selection.typeMessage)
                        .foregroundColor(.main)
                }
                
                Button(action: unflagPortfolio) {
                    Image(systemName: "bookmark.slash")
                        .foregroundColor(.accent)
                }
                .padding(.trailing, Constants.Dimens.spaceSemiXLarge)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(userData?.fullName ?? L.Selection.fullName)")
                        .foregroundColor(.black).brightness(Constants.Dimens.opacityLow)
                        .font(.body)
                    
                    if let userData = userData {
                        if userData.rating.isEmpty {
                            Text("📍 \(userData.location) • \(L.Selection.noRating)")
                                .font(.caption)
                                .foregroundColor(.mainText)
                        } else {
                            HStack(alignment: .center, spacing: Constants.Dimens.spaceXXSmall) {
                                Text("📍 \(userData.location) • " + String(format: "%.1f", userData.averageRating) + L.Profile.outOf5)
                                    .font(.caption)
                                
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                            }
                            .foregroundColor(.mainText)
                        }
                    }
                }
                .padding(.top, Constants.Dimens.spaceXXSmall)
                .padding(.leading, Constants.Dimens.spaceXLarge)
                
                Spacer()
            }
            
            HStack {
                Text(creatorData?.description ?? L.Selection.profileText)
                    .font(.body)
                    .foregroundColor(.subsequentText)
                
                Spacer()
            }
            .padding(.top, Constants.Dimens.spaceXSmall)
            .padding(.horizontal, Constants.Dimens.textFieldButtonSpace)
        }
        .skeleton(isLoading)
    }
}
