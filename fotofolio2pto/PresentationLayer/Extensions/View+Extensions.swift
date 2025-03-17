//
//  View+Extensions.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation
import SwiftUI

// Views
@MainActor
extension View {
    @inlinable func lifecycle(_ viewModel: BaseViewModel) -> some View {
        self
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
            }
    }
    
    func setupNavBarAndTitle(_ title: String, hideBack: Bool = false) -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.white, for: .navigationBar)
            .accentColor(
                .black
                    .opacity(Constants.Dimens.opacityHigh)
            )
            .navigationBarBackButtonHidden(hideBack)
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Skeleton
extension View {
    /// Redact a view with a shimmering effect aka show a skeleton
    /// - Inspiration taken from [Redacted View Modifier](https://www.avanderlee.com/swiftui/redacted-view-modifier/)
    @ViewBuilder
    func skeleton(
        _ condition: @autoclosure () -> Bool,
        duration: Double = 1.5,
        bounce: Bool = false
    ) -> some View {
        redacted(reason: condition() ? .placeholder : [])
            .shimmering(active: condition(), animation: .linear(duration: duration).repeatForever(autoreverses: bounce))
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    @ViewBuilder
    func disabledOverlay(
        _ condition: Bool
    ) -> some View {
        self
            .disabled(condition)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .fill(condition ? .black : .clear)
                    .opacity(Constants.Dimens.opacityLow)
            )
            .animation(.default, value: condition)
    }
}

extension View {
    func toast(toastData: Binding<ToastData>) -> some View {
        self.modifier(ToastModifier(toastData: toastData))
    }
}
