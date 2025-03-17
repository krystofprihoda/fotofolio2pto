//
//  Toast.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 17.03.2025.
//

import SwiftUI

enum ToastType {
    case neutral, success, error

    var color: Color {
        switch self {
        case .neutral: return .gray
        case .success: return .green
        case .error: return .red
        }
    }
}

struct ToastData {
    var message: String = ""
    var type: ToastType = .success
    var duration: DispatchTimeInterval = .seconds(3)
}

struct ToastView: View {
    let data: ToastData
    
    var body: some View {
        Text(data.message)
            .foregroundColor(.white)
            .padding()
            .background(data.type.color.opacity(Constants.Dimens.opacityHigh))
            .cornerRadius(Constants.Dimens.radiusXSmall)
            .shadow(radius: Constants.Dimens.radiusXSmall)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.3), value: data.message)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toastData: ToastData

    func body(content: Content) -> some View {
        ZStack {
            content
            
            if !toastData.message.isEmpty {
                VStack {
                    Spacer()
                    
                    ToastView(data: toastData)
                        .padding(.bottom, Constants.Dimens.spaceXXLarge)
                }
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + toastData.duration) {
                        withAnimation {
                            toastData.message = ""
                        }
                    }
                }
            }
        }
    }
}
