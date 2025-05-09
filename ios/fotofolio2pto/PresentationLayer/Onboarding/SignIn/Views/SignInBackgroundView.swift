//
//  SignInBackgroundView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 18.04.2025.
//

import SwiftUI

struct SignInBackgroundView: View {
    
    private let gradientDegrees: Double = 30
    private let duration: Double = 1.5
    
    @State private var animateGradient: Bool = false
    
    var body: some View {
        ZStack {
            Image("sydney_opera_house")
                .resizable()
                .scaledToFill()
            
            LinearGradient(colors: [.white, .main], startPoint: .topLeading, endPoint: .bottomTrailing)
                .hueRotation(.degrees(animateGradient ? gradientDegrees : 0))
                .onAppear {
                    withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
                .opacity(0.9)
        }
            .edgesIgnoringSafeArea(.all)
    }
}
