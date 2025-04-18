//
//  ProfileUserInfoView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct ProfileUserInfoView: View {
    
    private let user: User?
    private let creator: Creator?
    private let profileOwner: Bool
    private let onGiveRatingTap: () -> Void
    
    init(user: User?, creator: Creator?, profileOwner: Bool, onGiveRatingTap: @escaping () -> Void) {
        self.user = user
        self.creator = creator
        self.profileOwner = profileOwner
        self.onGiveRatingTap = onGiveRatingTap
    }
    
    var body: some View {
        if let user = user {
            VStack {
                HStack {
                    ProfilePictureView(profilePicture: user.profilePicture, width: Constants.Dimens.frameSizeMedium)
                        .padding(.leading, Constants.Dimens.spaceSemiXLarge)
                    
                    VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
                        Text(user.fullName)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.bottom, Constants.Dimens.spaceXSmall)
                        
                        Text(user.location)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .opacity(Constants.Dimens.opacityHigh)
                            .padding(.bottom, Constants.Dimens.spaceXXSmall)
                        
                        if !user.rating.isEmpty {
                            HStack(alignment: .center, spacing: Constants.Dimens.spaceXXSmall) {
                                Text(String(format: "%.1f", user.averageRating) + L.Profile.outOf5)
                                    .font(.caption)
                                
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                            }
                            .foregroundColor(.black)
                            .opacity(Constants.Dimens.opacityHigh)
                        } else {
                            Text(L.Profile.noRating)
                                .font(.footnote)
                                .foregroundColor(.black)
                                .opacity(Constants.Dimens.opacityHigh)
                        }
                        
                        if !profileOwner {
                            Button(action: onGiveRatingTap, label: {
                                Text(L.Profile.giveRating)
                                    .font(.footnote)
                                    .underline()
                                    .foregroundColor(.red).brightness(Constants.Dimens.opacityLow)
                                    .padding(.top, Constants.Dimens.spaceXXSmall)
                                    .padding(.top, Constants.Dimens.spaceSmall)
                            })
                        }
                    }
                    .padding(.leading, Constants.Dimens.spaceXSmall)
                    
                    Spacer()
                }
                .padding(.top, Constants.Dimens.spaceSemiMedium)
                
                Divider()
                    .padding([.leading, .trailing], Constants.Dimens.spaceLarge)
                    .padding([.top, .bottom], Constants.Dimens.spaceXSmall)
                
                if let creator = creator {
                    VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
                        HStack {
                            Text("\(creator.yearsOfExperience)" + yearFormatString(creator.yearsOfExperience))
                                .font(.subheadline)
                                .padding(.top, Constants.Dimens.spaceXSmall)
                                .padding(.leading, Constants.Dimens.spaceSemiXLarge)
                                .foregroundColor(.black)

                            
                            Spacer()
                        }
                        
                        Text(creator.description)
                            .lineSpacing(Constants.Dimens.spaceXXSmall)
                            .font(.body)
                            .padding(.top, Constants.Dimens.spaceXSmall)
                            .padding(.leading, Constants.Dimens.spaceSemiXLarge)
                            .padding(.trailing, Constants.Dimens.spaceXXSmall)
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                        .padding([.leading, .trailing], Constants.Dimens.textFieldButtonSpace)
                        .padding(.bottom, Constants.Dimens.spaceSemiMedium)
                        .padding(.top, Constants.Dimens.spaceXSmall)
                }
            }
        } else {
            ProgressView()
                .padding(Constants.Dimens.spaceLarge)
        }
    }
    
    func yearFormatString(_ yearsOfExperience: Int) -> String {
        if yearsOfExperience == 1 { return L.Profile.singleYearExperience }
        if yearsOfExperience < 5 { return L.Profile.lessThanFiveExperience }
        return L.Profile.moreThanFiveExperience
    }
}

#Preview {
    ProfileUserInfoView(user: .dummy1, creator: .dummy1, profileOwner: true, onGiveRatingTap: {})
}
