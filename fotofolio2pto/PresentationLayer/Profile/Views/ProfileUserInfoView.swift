//
//  ProfileUserInfoView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct ProfileUserInfoView: View {
    private let user: User?
    private let profileOwner: Bool
    
    init(user: User?, profileOwner: Bool) {
        self.user = user
        self.profileOwner = profileOwner
    }
    
    var body: some View {
        if let user = user {
            VStack {
                HStack {
                    ProfilePictureView(profilePicture: user.profilePicture)
                        .padding(.leading, 20)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(user.fullName)
                            .font(.system(size: 17))
                            .foregroundColor(.black).brightness(0.2)
                            .padding(.bottom, 4)
                        
                        Text(user.location)
                            .font(.system(size: 13))
                            .foregroundColor(.black).brightness(0.3)
                            .padding(.bottom, 2)
                        
                        if !user.ratings.isEmpty {
                            HStack {
                                Text(String(format: "%.1f", user.calculateRating()) + " z 5")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black).brightness(0.3)
                                
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.black).brightness(0.3)
                                    .offset(x: -5)
                            }
                        } else {
                            Text("Zatím bez hodnocení.")
                                .font(.system(size: 12))
                                .foregroundColor(.black).brightness(0.3)
                        }
                        
                        if !profileOwner {
                            Button(action: { }, label: {
                                Text("Udělit hodnocení")
                                    .font(.system(size: 12))
                                    .underline()
                                    .foregroundColor(.red).brightness(0.25)
                            })
                        }
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                Divider()
                    .padding([.leading, .trailing], Constants.Dimens.spaceLarge)
                    .padding([.top, .bottom], Constants.Dimens.spaceXSmall)
                
                if let creator = user.creator {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("\(creator.yearsOfExperience)" + yearFormatString(creator.yearsOfExperience))
                                .font(.system(size: 15))
                                .padding(.top, 5)
                                .padding(.leading, 23)
                                .foregroundColor(.black).brightness(0.3)
                            
                            Spacer()
                        }
                        
                        Text(creator.profileText)
                            .lineSpacing(1)
                            .font(.system(size: 15))
                            .padding(.top, 6)
                            .padding(.leading, 23)
                            .padding(.trailing, 5)
                            .foregroundColor(.gray).brightness(0.1)
                    }
                    
                    Divider()
                        .padding(.leading, 18)
                        .padding(.trailing, 18)
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                }
            }
        } else {
            ProgressView()
                .padding()
        }
    }
    
    func yearFormatString(_ yearsOfExperience: Int) -> String {
        if yearsOfExperience == 1 { return " rok fotografem" }
        if yearsOfExperience < 5 { return " roky fotografem" }
        return " let fotografem"
    }
}

#Preview {
    ProfileUserInfoView(user: .dummy1, profileOwner: true)
}
