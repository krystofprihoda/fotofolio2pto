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
                RemoteImageView(urlString: urlStr) {
                    AnimatedMeshPlaceholder(style: .pastelEarthy)
                        .clipShape(.rect(cornerRadius: Constants.Dimens.radiusXSmall))
                }
            }
        }
        .frame(width: size, height: size)
        .clipped()
        .cornerRadius(Constants.Dimens.radiusXSmall)
    }
}
