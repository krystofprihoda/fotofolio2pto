//
//  ProfilePictureView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import SwiftUI

struct ProfilePictureView: View {
    
    private let profilePicture: IImage?
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
            if case MyImageEnum.remote(let urlString) = pic.src, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: width)
                        .clipped()
                        .cornerRadius(Constants.Dimens.radiusMax)
                } placeholder: {
                    placeholderView
                        .skeleton(true)
                }
            } else if case MyImageEnum.local(let image) = pic.src {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width)
                    .clipped()
                    .cornerRadius(Constants.Dimens.radiusMax)
            }
        } else {
            placeholderView
        }
    }
    
    private var placeholderView: some View {
        Circle()
            .foregroundColor(.mainText)
            .brightness(Constants.Dimens.opacityLow)
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: width)
    }
}

#Preview {
    ProfilePictureView()
}
