//
//  PortfolioDetailView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct PortfolioDetailView: View {
    private let mediaWidth: CGFloat
    private let portfolio: Portfolio
    private let portfolioAuthorDetailViewModel: PortfolioAuthorDetailViewModel
    
    init(
        mediaWidth: CGFloat,
        portfolio: Portfolio,
        unflagPortfolio: @escaping () -> Void,
        showProfile: @escaping () -> Void,
        sendMessage: @escaping () -> Void
    ) {
        self.mediaWidth = mediaWidth - Constants.Dimens.spaceXXLarge
        self.portfolio = portfolio
        self.portfolioAuthorDetailViewModel = .init(creatorId: portfolio.creatorId, unflagPortfolio: unflagPortfolio, showProfile: showProfile, sendMessage: sendMessage)
    }
    
    var body: some View {
        VStack {
            /// Folio Author
            PortfolioAuthorDetailView(viewModel: portfolioAuthorDetailViewModel)
            
            /// Carousel
            PhotoCarouselView(mediaWidth: mediaWidth, photos: portfolio.photos)
            
            /// Description
            HStack {
                Text(portfolio.description)
                    .font(.system(size: 16))
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
                Spacer()
            }
            .padding(.top, 5)
            .padding(.leading, 21)
            .padding(.trailing, 21)
        }
        .padding(.bottom, 10)
    }
}

//#Preview {
//    PortfolioDetailView(mediaWidth: 350, portfolio: .dummyPortfolio1, unflagPortfolio: {}, showProfile: {}, sendMessage: {})
//}
