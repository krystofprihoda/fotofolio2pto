//
//  RemoteImageView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 05.04.2025.
//

import SwiftUI
import Resolver

struct RemoteImageView: View {
    @StateObject private var viewModel: RemoteImageViewModel
    
    init(url: String) {
        _viewModel = StateObject(wrappedValue: RemoteImageViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            if let imageSrc = viewModel.state.imageSrc {
                Image(uiImage: imageSrc)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if viewModel.state.isLoading {
                RoundedRectangle(cornerRadius: Constants.Dimens.spaceXSmall)
                    .foregroundColor(.gray.opacity(Constants.Dimens.opacityLow))
                    .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                    .padding(.leading, Constants.Dimens.spaceLarge)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    )
            } else if let error = viewModel.state.error {
                VStack {
                    Text("Failed to load image: \(error.localizedDescription)")
                        .font(.caption)
                        .foregroundColor(.red)
                    Button(action: {
                        viewModel.onIntent(.retryFetchingImage)
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.blue)
                    }
                    .padding(.top, Constants.Dimens.spaceSmall)
                }
                .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                .padding(.leading, Constants.Dimens.spaceLarge)
            }
        }
    }
}
