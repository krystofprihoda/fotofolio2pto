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
                    else if !viewModel.state.filter.isEmpty, viewModel.state.portfolios.isEmpty {
                        VStack(alignment: .center) {
                            Text(L.Feed.noFilterResults)
                                .foregroundColor(.red)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    } else {
                        LazyVStack {
                            ForEach(viewModel.state.portfolios, id: \.id) { portfolio in
                                let isFlagged = viewModel.state.flaggedPortfolioIds.contains(where: { $0 == portfolio.id })
                                
                                PortfolioView(
                                    portfolio: portfolio,
                                    mediaWidth: geo.size.width,
                                    isFlagged: isFlagged,
                                    flagAction: { viewModel.onIntent(.flagPortfolio(portfolio.id)) },
                                    unflagAction: { viewModel.onIntent(.unflagPortfolio(portfolio.id)) },
                                    openProfileAction: { viewModel.onIntent(.showProfile(creatorId: portfolio.creatorId)) }
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
        .navigationBarItems(leading: sortButton, trailing: filterButton)
        .animation(.default, value: viewModel.state)
        .setupNavBarAndTitle(L.Feed.title)
        .lifecycle(viewModel)
    }
    
    private var sortButton: some View {
        Menu(L.Feed.sort) {
            Button(action: { viewModel.onIntent(.sortByDate) }) {
                Label(L.Feed.sortByDate, systemImage: viewModel.state.sortBy == .date ? "checkmark" : "")
            }
            
            Button(action: { viewModel.onIntent(.sortByRating) }) {
                Label(L.Feed.sortByRating, systemImage: viewModel.state.sortBy == .rating ? "checkmark" : "")
            }
        }
    }
    
    private var filterButton: some View {
        Button(L.Feed.filter, action: { viewModel.onIntent(.filter) })
    }
    
    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.Dimens.spaceSmall) {
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
                    })
                }
            }
            .padding(.leading, Constants.Dimens.spaceLarge)
        }
    }
}

#Preview {
    FeedView(viewModel: .init(flowController: nil, signedInUserId: ""))
}
