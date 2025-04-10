//
//  HorizontalWheelPicker.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 10.03.2025.
//

import SwiftUI

struct HorizontalWheelPicker: View {
    @Binding private var selectedValue: Int
    let lowestValue = 0
    let highestValue = 100
    let blurThreshold = 3
    let animationDuration = 2.0
    let animationDelay = 0.5

    init(selectedValue: Binding<Int>) {
        self._selectedValue = selectedValue
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(lowestValue...highestValue, id: \.self) { idx in
                        Text("\(idx)")
                            .font(.title3)
                            .foregroundColor(selectedValue == idx ? .white : .black)
                            .gesture(TapGesture().onEnded {
                                withAnimation(.linear) {
                                    proxy.scrollTo(idx, anchor: .center)
                                    selectedValue = idx
                                }
                            })
                            .id(idx)
                            .padding(.horizontal, Constants.Dimens.spaceLarge)
                            .padding(.vertical, Constants.Dimens.spaceMedium)
                            .background(
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(idx == selectedValue ? Color.blue : Color.clear)
                            )
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                    withAnimation(.spring(duration: animationDuration)) {
                        proxy.scrollTo(selectedValue, anchor: .center)
                    }
                }
            }
        }
        .mask(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(selectedValue > lowestValue + blurThreshold ? 0 : 1),
                    Color.black.opacity(1),
                    Color.black.opacity(1),
                    Color.black.opacity(selectedValue < highestValue - blurThreshold ? 0 : 1)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}
