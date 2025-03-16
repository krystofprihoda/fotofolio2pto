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
                            let isFlagHidden = viewModel.state.signedInUser == portfolio.author.username
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
                    .padding(.top)
                }
            }
            .refreshable(action: { viewModel.onIntent(.fetchPortfolios(isRefreshing: true)) })
        }
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
        .setupNavBarAndTitle(L.Feed.title)
        .lifecycle(viewModel)
    }
}

#Preview {
    FeedView(viewModel: .init(flowController: nil, signedInUser: ""))
}
