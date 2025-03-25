//
//  FeedView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject private var viewModel: FeedViewModel
        
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    if viewModel.state.isLoading {
                        VStack(alignment: .center) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    else if !viewModel.state.filter.isEmpty && viewModel.state.portfolios.isEmpty {
                        VStack(alignment: .center) {
                            Text(L.Feed.noFilterResults)
                                .foregroundColor(.red)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    } else {
                        LazyVStack {
                            ForEach(viewModel.state.portfolios, id: \.id) { portfolio in
                                let isFlagHidden = viewModel.state.signedInUserId == String(portfolio.author.id)
                                let isFlagged = viewModel.state.flaggedPortfolioIds.contains(where: { $0 == portfolio.id })
                                
                                PortfolioView(
                                    portfolio: portfolio,
                                    mediaWidth: geo.size.width,
                                    hideFlag: isFlagHidden,
                                    isFlagged: isFlagged,
                                    flagAction: { viewModel.onIntent(.flagPortfolio(portfolio.id)) },
                                    unflagAction: { viewModel.onIntent(.unflagPortfolio(portfolio.id)) },
                                    openProfileAction: { viewModel.onIntent(.showProfile(portfolio.author)) }
                                )
                                .skeleton(viewModel.state.isRefreshing)
                            }
                        }
                        .frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                        .padding(
                            .top,
                            viewModel.state.filter.isEmpty ?
                            Constants.Dimens.spaceLarge :
                            Constants.Dimens.spaceXXXLarge
                        )
                    }
                }
                .refreshable(action: { viewModel.onIntent(.fetchPortfolios(isRefreshing: true)) })
                
                categoryBar
                    .padding(.top, Constants.Dimens.spaceLarge)
            }
        }
        .toast(toastData: Binding(get: { viewModel.state.toastData ?? nil }, set: { viewModel.onIntent(.setToastData($0)) }))
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Menu(L.Feed.sort) {
                    Button(L.Feed.sortByDate, action: { viewModel.onIntent(.sortByDate) })
                    Button(L.Feed.soryByRating, action: { viewModel.onIntent(.sortByRating) })
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(L.Feed.filter, action: { viewModel.onIntent(.filter) })
            }
        }
        .animation(.default, value: viewModel.state)
        .setupNavBarAndTitle(L.Feed.title)
        .lifecycle(viewModel)
    }
    
    var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.Dimens.spaceNone) {
                ForEach(Array(zip(viewModel.state.filter.indices, viewModel.state.filter)), id: \.0) { idx, category in
                    Button(action: { viewModel.onIntent(.removeCategory(category)) }, label: {
                        HStack {
                            Text(category)
                                .font(.footnote)
                                .fixedSize(horizontal: true, vertical: false)
                                .foregroundColor(.white)
                            
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: Constants.Dimens.spaceSmall, height: Constants.Dimens.spaceSmall)
                                .foregroundColor(.white)
                                .padding(.leading, Constants.Dimens.spaceXXSmall)
                        }
                        .padding(.horizontal, Constants.Dimens.spaceMedium)
                        .padding(.vertical, Constants.Dimens.spaceSemiMedium)
                        .background(
                            .black
                                .opacity(Constants.Dimens.opacityMid)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall))
                        .padding(.leading, idx == 0 ? Constants.Dimens.spaceLarge : Constants.Dimens.spaceSmall)
                    })
                }
            }
        }
    }
}

#Preview {
    FeedView(viewModel: .init(flowController: nil, signedInUserId: ""))
}
