//
//  PhotoCarouselView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct PhotoCarouselView: View {
    private let mediaWidth: CGFloat?
    private let photos: [IImage]
    
    init(
        mediaWidth: CGFloat?,
        photos: [IImage]
    ) {
        self.mediaWidth = mediaWidth
        self.photos = photos
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.Dimens.spaceMedium) {
                ForEach(photos) { photo in
                    if case MyImageEnum.remote(let url) = photo.src {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fill)
                                .frame(width: mediaWidth)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        } placeholder: {
                            ZStack {
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(.gray).brightness(Double.random(in: 0.15...0.4))
                                    .aspectRatio(1.0, contentMode: .fill)
                                    .frame(width: mediaWidth)

                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        }
                    } else if case MyImageEnum.local(let image) = photo.src {
                        image
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fill)
                            .frame(width: mediaWidth)
                            .cornerRadius(Constants.Dimens.radiusXSmall)
                    }
                }
            }
            .padding([.leading, .trailing], Constants.Dimens.spaceMedium)
        }
    }
}

#Preview {
    PhotoCarouselView(mediaWidth: 350, photos: [])
}
