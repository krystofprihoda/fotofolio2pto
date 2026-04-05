//
//  AnimatedMeshPlaceholder.swift
//  fotofolio2pto
//
//  Created by k r y š t o f on 05.04.2026.
//


import SwiftUI

struct AnimatedMeshPlaceholder: View {
    enum Style {
        case pastelEarthy // Image 1 (Richard Sancho)
        case brightWarm   // Image 2 (Leonard)
        case darkCenter   // Image 3 (French Graphic Designer)
        case vibrantDark  // Image 4 (monopo)
        
        var colors: [Color] {
            switch self {
            case .pastelEarthy:
                return [
                    Color(red: 0.93, green: 0.90, blue: 0.87), Color(red: 0.85, green: 0.62, blue: 0.58), Color(red: 0.53, green: 0.73, blue: 0.80),
                    Color(red: 0.67, green: 0.72, blue: 0.55), Color(red: 0.60, green: 0.55, blue: 0.55), Color(red: 0.50, green: 0.60, blue: 0.65),
                    Color(red: 0.45, green: 0.48, blue: 0.40), Color(red: 0.35, green: 0.30, blue: 0.35), Color(red: 0.88, green: 0.85, blue: 0.82)
                ]
            case .brightWarm:
                return [
                    Color(red: 0.85, green: 0.85, blue: 0.90), Color(red: 0.95, green: 0.75, blue: 0.60), Color(red: 1.00, green: 0.30, blue: 0.10),
                    Color(red: 0.90, green: 0.90, blue: 0.95), Color(red: 0.85, green: 0.80, blue: 0.90), Color(red: 0.95, green: 0.60, blue: 0.50),
                    Color(red: 0.80, green: 0.90, blue: 0.95), Color(red: 0.85, green: 0.85, blue: 0.90), Color(red: 0.75, green: 0.75, blue: 0.80)
                ]
            case .darkCenter:
                return [
                    Color(red: 0.90, green: 0.90, blue: 0.90), Color(red: 0.20, green: 0.50, blue: 0.55), Color(red: 0.90, green: 0.90, blue: 0.90),
                    Color(red: 0.90, green: 0.90, blue: 0.90), Color(red: 0.10, green: 0.15, blue: 0.25), Color(red: 0.60, green: 0.20, blue: 0.30),
                    Color(red: 0.90, green: 0.90, blue: 0.90), Color(red: 0.90, green: 0.90, blue: 0.90), Color(red: 0.90, green: 0.90, blue: 0.90)
                ]
            case .vibrantDark:
                return [
                    Color(red: 0.05, green: 0.10, blue: 0.20), Color(red: 0.00, green: 0.00, blue: 0.00), Color(red: 0.80, green: 0.30, blue: 0.05),
                    Color(red: 0.20, green: 0.50, blue: 0.70), Color(red: 0.90, green: 0.40, blue: 0.10), Color(red: 0.10, green: 0.05, blue: 0.05),
                    Color(red: 0.85, green: 0.35, blue: 0.05), Color(red: 0.60, green: 0.20, blue: 0.05), Color(red: 0.00, green: 0.00, blue: 0.00)
                ]
            }
        }
    }
    
    private let style: Style
    @State private var isAnimating = false
    
    init(style: Style, isAnimating: Bool = false) {
        self.style = style
        self.isAnimating = isAnimating
    }
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                .init(0, 0), .init(isAnimating ? 0.6 : 0.4, 0), .init(1, 0),
                .init(0, isAnimating ? 0.6 : 0.4), .init(isAnimating ? 0.7 : 0.3, isAnimating ? 0.3 : 0.7), .init(1, isAnimating ? 0.4 : 0.6),
                .init(0, 1), .init(isAnimating ? 0.4 : 0.6, 1), .init(1, 1)
            ],
            colors: style.colors
        )
        .overlay {
            Asset.crossgrain.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blendMode(.overlay)
        }
        .clipped()
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
    }
}
