//
//  NotCreatorView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct NotCreatorView: View {
    
    private let numOfRows = 2
    private let firstRowText = ["Uživatel", "není", "tvůrce."]
    private let secondRowText = ["Žádná", "portfolia", "k", "zobrazení."]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(firstRowText, id: \.self) { text in
                        ZStack {
                            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                .fill(Color.gray).brightness(
                                    Double.random(in:
                                        Constants.Dimens.opacityLow...Constants.Dimens.opacityMid
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(secondRowText, id: \.self) { text in
                        ZStack {
                            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                .fill(Color.gray).brightness(
                                    Double.random(in:
                                        Constants.Dimens.opacityLow...Constants.Dimens.opacityMid
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
            .padding(.top, 5)
        }
        .padding(.leading, 25)
        .padding(.top, 5)
    }
}

#Preview {
    NotCreatorView()
}
