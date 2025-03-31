//
//  NotCreatorView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct NotCreatorView: View {
    
    var body: some View {
        VStack {
            let textFormatted = splitIntoWords(sentences: [L.Profile.userNotACreator, L.Profile.noPortfoliosToShow])
            
            ForEach(textFormatted, id: \.self) { textArray in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(textArray, id: \.self) { text in
                            ZStack {
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(Color.gray).brightness(
                                        Double.random(in:
                                            Constants.Dimens.opacityMid...Constants.Dimens.opacityHigh
                                        )
                                    )
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: Constants.Dimens.frameSizeXLarge, height: Constants.Dimens.frameSizeXLarge)
                                    .padding(.leading, 5)
                                
                                Text(text)
                            }
                        }
                    }
                }
            }
        }
        .padding(.leading, 25)
        .padding(.top, 5)
    }
    
    func splitIntoWords(sentences: [String]) -> [[String]] {
        return sentences.map { $0.components(separatedBy: .whitespaces) }
    }
}

#Preview {
    NotCreatorView()
}
