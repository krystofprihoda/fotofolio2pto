//
//  PhotoView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 18.04.2025.
//


import SwiftUI

struct PhotoView: View {
    
    let image: MyImageEnum
    let size: CGFloat

    init(image: MyImageEnum, size: CGFloat) {
        self.image = image
        self.size = size
    }

    var body: some View {
        Group {
            switch image {
            case .local(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)

            case .remote(let urlStr):
                if let url = URL(string: urlStr) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                            .fill(.mainText)
                            .brightness(Double.random(in: 0.15...0.4))
                            .skeleton(true)
                    }
                } else {
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .fill(.red)
                        .brightness(Constants.Dimens.opacityMid)
                        .skeleton(true)
                }
            }
        }
        .frame(width: size, height: size)
        .clipped()
        .cornerRadius(Constants.Dimens.radiusXSmall)
    }
}
