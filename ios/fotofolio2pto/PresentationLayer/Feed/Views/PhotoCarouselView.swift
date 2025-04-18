//
//  PhotoCarouselView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct PhotoCarouselView: View {
    private let mediaWidth: CGFloat
    private let photos: [IImage]
    
    init(
        mediaWidth: CGFloat,
        photos: [IImage]
    ) {
        self.mediaWidth = mediaWidth
        self.photos = photos
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.Dimens.spaceMedium) {
                ForEach(photos) { photo in
                    PhotoView(image: photo.src, size: mediaWidth)
                }
            }
            .padding([.leading, .trailing], Constants.Dimens.spaceMedium)
        }
    }
}

#Preview {
    PhotoCarouselView(mediaWidth: 350, photos: [])
}
