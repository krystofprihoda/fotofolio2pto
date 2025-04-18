//
//  FotofolioAnimatedLogoView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 18.04.2025.
//

import SwiftUI

struct FotofolioAnimatedLogoView: View {
    @State private var scaleFirst: CGFloat = 1.0
    @State private var scaleSecond: CGFloat = 1.0
    @State private var scaleThird: CGFloat = 1.0
    
    private let coef = 1.15
    private let duration = 7.0
    private let resize = 1.35
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .stroke(lineWidth: Constants.Dimens.lineWidthXSmall)
                    .frame(width: Constants.Dimens.frameSizeLarge, height: Constants.Dimens.frameSizeLarge)
                    .opacity(Constants.Dimens.opacityHigh)
                    .scaleEffect(scaleFirst)
                
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .stroke(lineWidth: Constants.Dimens.lineWidthXSmall)
                    .frame(width: Constants.Dimens.frameSizeXLarge, height: Constants.Dimens.frameSizeXLarge)
                    .opacity(Constants.Dimens.opacityMid)
                    .scaleEffect(scaleSecond)
                
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .stroke(lineWidth: Constants.Dimens.lineWidthXSmall)
                    .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                    .opacity(Constants.Dimens.opacityLow)
                    .scaleEffect(scaleThird)
            }
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: scaleFirst
            )
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: scaleSecond
            )
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: scaleThird
            )
            .onAppear {
                scaleFirst = resize
                scaleSecond = resize * coef
                scaleThird = resize * coef * coef
            }
            .foregroundColor(.white)
            .offset(y: Constants.Dimens.spaceXSmall)
            
            Image("fotofolio_text_dark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
        }
    }
}
