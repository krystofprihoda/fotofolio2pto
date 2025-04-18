//
//  PortfolioDetailView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct PortfolioDetailView: View {
    @StateObject private var viewModel: PortfolioDetailViewModel
    
    private let mediaWidth: CGFloat
    
    init(
        mediaWidth: CGFloat,
        portfolio: Portfolio,
        portfolioSelectionFlowDelegate: PortfolioSelectionFlowDelegate
    ) {
        self.mediaWidth = mediaWidth - Constants.Dimens.spaceXXLarge
        _viewModel = StateObject(
            wrappedValue: PortfolioDetailViewModel(
                portfolio: portfolio,
                portfolioSelectionFlowDelegate: portfolioSelectionFlowDelegate
            )
        )
    }
    
    var body: some View {
        VStack {
            /// Folio Author
            PortfolioAuthorDetailView(
                isLoading: viewModel.state.isLoading,
                userData: viewModel.state.userData,
                creatorData: viewModel.state.creatorData,
                showProfile: { viewModel.onIntent(.showProfile) },
                sendMessage: { viewModel.onIntent(.sendMessage) },
                unflagPortfolio: { viewModel.onIntent(.unflagPortfolio) }
            )
            
            /// Carousel
            PhotoCarouselView(mediaWidth: mediaWidth, photos: viewModel.state.portfolio.photos)
            
            /// Price
            HStack(spacing: Constants.Dimens.spaceXSmall) {
                if case .fixed(let price) = viewModel.state.portfolio.price {
                    Text(String(price) + L.Selection.czk)
                        .font(.footnote)
                        .padding(Constants.Dimens.spaceSmall)
                        .background(.orange)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                } else {
                    Text(L.Profile.priceOnRequest)
                        .font(.footnote)
                        .padding(Constants.Dimens.spaceSmall)
                        .background(.orange)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                }
                
                Spacer()
            }
            .padding(.horizontal, Constants.Dimens.spaceSemiXLarge)
            
            /// Description
            HStack {
                Text(viewModel.state.portfolio.description)
                    .font(.body)
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
                Spacer()
            }
            .padding(.horizontal, Constants.Dimens.spaceSemiXLarge)
        }
        .padding(.bottom, Constants.Dimens.spaceSemiMedium)
        .toast(toastData: Binding(get: { viewModel.state.toastData }, set: { viewModel.onIntent(.setToastData($0)) }))
    }
}
