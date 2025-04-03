//
//  NotCreatorView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct NotCreatorView: View {
    
    var body: some View {
        let textFormatted = splitIntoWords(sentences: [L.Profile.userNotACreator, L.Profile.noPortfoliosToShow])
        
        VStack(spacing: Constants.Dimens.spaceNone) {
            ForEach(textFormatted, id: \.self) { textArray in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Constants.Dimens.spaceMedium) {
                        ForEach(textArray, id: \.self) { text in
                            ZStack {
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(Color.black).brightness(
                                        Double.random(in:
                                            Constants.Dimens.opacityLow...Constants.Dimens.opacityMid
                                        )
                                    )
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: Constants.Dimens.frameSizeXLarge, height: Constants.Dimens.frameSizeXLarge)
                                    .cornerRadius(Constants.Dimens.radiusXSmall)
                                
                                Text(text)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .padding([.leading, .trailing, .bottom], Constants.Dimens.spaceMedium)
                }
            }
        }
    }
    
    func splitIntoWords(sentences: [String]) -> [[String]] {
        return sentences.map { $0.components(separatedBy: .whitespaces) }
    }
}

#Preview {
    NotCreatorView()
}
