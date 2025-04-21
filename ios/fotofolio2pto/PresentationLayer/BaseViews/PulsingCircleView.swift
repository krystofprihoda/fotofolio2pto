//
//  PulsingCircleView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 10.03.2025.
//

import SwiftUI

struct PulsingCircleView: View {
    @State private var scale: CGFloat = 1.0
    @State private var color: Color = .main
    
    private let duration = 1.0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: Constants.Dimens.frameSizeLarge, height: Constants.Dimens.frameSizeLarge)
            .scaleEffect(scale)
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: scale
            )
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: color
            )
            .onAppear {
                scale = 1.5
                color = .gray
            }
    }
}
