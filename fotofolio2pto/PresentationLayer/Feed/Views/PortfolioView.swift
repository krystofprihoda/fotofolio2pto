//
//  PortfolioView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct PortfolioView: View {
    
    private let portfolio: Portfolio
    private let mediaWidth: CGFloat
    private let hideFlag: Bool
    private let isFlagged: Bool
    private let flagAction: () -> Void
    private let unflagAction: () -> Void
    private let openProfileAction: () -> Void
    
    init(
        portfolio: Portfolio,
        mediaWidth: CGFloat,
        hideFlag: Bool,
        isFlagged: Bool,
        flagAction: @escaping () -> Void,
        unflagAction: @escaping () -> Void,
        openProfileAction: @escaping () -> Void
    ) {
        self.portfolio = portfolio
        self.mediaWidth = mediaWidth - Constants.Dimens.spaceXXLarge
        self.hideFlag = hideFlag
        self.isFlagged = isFlagged
        self.flagAction = flagAction
        self.unflagAction = unflagAction
        self.openProfileAction = openProfileAction
    }
    
    var body: some View {
        VStack(spacing: Constants.Dimens.spaceMedium) {
            /// Top bar
            HStack {
                Button(action: openProfileAction, label: {
                    Text("@" + portfolio.author.username)
                        .font(.title2)
                        .foregroundColor(.pink)
                })
                
                Spacer()
                
                if !hideFlag {
                    Button(action: isFlagged ? unflagAction : flagAction) {
                        Image(systemName: isFlagged ? "bookmark.fill" : "bookmark")
                            .font(.title3)
                            .foregroundColor(isFlagged ? .red : .gray)
                            .transition(.opacity)
                    }
                }
            }
            .padding([.leading, .trailing], Constants.Dimens.spaceLarge)
            
            /// Media
            PhotoCarouselView(mediaWidth: mediaWidth, photos: portfolio.photos)
                .onTapGesture(count: 2) { if !hideFlag { flagAction() } }
            
            /// Description
            HStack {
                Text(portfolio.description)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.top, 5)
            .padding([.leading, .trailing, .bottom])
        }
        .transition(.opacity)
    }
}

#Preview {
    PortfolioView(
        portfolio: .dummyPortfolio2,
        mediaWidth: 350,
        hideFlag: false,
        isFlagged: true,
        flagAction: {},
        unflagAction: {},
        openProfileAction: {}
    )
}
