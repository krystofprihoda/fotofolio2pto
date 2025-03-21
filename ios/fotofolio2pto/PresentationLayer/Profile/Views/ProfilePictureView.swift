//
//  ProfilePictureView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import SwiftUI

struct ProfilePictureView: View {
    @State private var profilePicture: IImage?
    
    private var width: Double
    
    init(
        profilePicture: IImage? = nil,
        width: Double = 50.0
    ) {
        self.profilePicture = profilePicture
        self.width = width
    }
    
    var body: some View {
        if let pic = profilePicture {
            if case MyImageEnum.remote(let url) = pic.src {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: width)
                        .clipped()
                        .cornerRadius(Constants.Dimens.radiusMax)
                } placeholder: {
                    ZStack {
                        Circle()
                            .foregroundColor(.gray).brightness(Constants.Dimens.opacityLow)
                            .aspectRatio(1.0, contentMode: .fit)

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(width: width)
                }
            } else if case MyImageEnum.local(let img) = pic.src {
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width)
                    .clipped()
                    .cornerRadius(Constants.Dimens.radiusMax)
            }
        } else {
            Circle()
                .foregroundColor(.gray).brightness(Constants.Dimens.opacityLow)
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: width)
        }
    }
}

#Preview {
    ProfilePictureView()
}
