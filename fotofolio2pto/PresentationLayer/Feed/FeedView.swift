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
                        Text("Filtrování neodpovídá žádný výsledek.")
                            .foregroundColor(.red)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                } else {
                    LazyVStack {
                        ForEach(viewModel.state.portfolios, id: \.id) { portfolio in
                            PortfolioView(
                                portfolio: portfolio,
                                mediaWidth: geo.size.width - Constants.Dimens.spaceXXLarge,
                                hideFlag: viewModel.state.signedInUser == portfolio.author.username,
                                isFlagged: viewModel.state.flaggedPortfolioIds.contains(where: { $0 == portfolio.id }),
                                flagAction: { viewModel.onIntent(.flagPortfolio(portfolio.id)) },
                                unflagAction: { viewModel.onIntent(.unflagPortfolio(portfolio.id)) },
                                openProfileAction: { viewModel.onIntent(.showProfile(portfolio.author)) }
                            )
                        }
                    }
                    .frame(width: geo.size.width)
                    .frame(minHeight: geo.size.height)
                    .padding(.top)
                }
            }
            .refreshable(action: { viewModel.onIntent(.fetchPortfolios) })
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Menu("Seřadit") {
                    Button("Podle data", action: { viewModel.onIntent(.sortByDate) })
                    Button("Podle hodnocení", action: { viewModel.onIntent(.sortByRating) })
                }
                .padding(.leading, 5)
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Filtrovat", action: { viewModel.onIntent(.filter) })
                .padding(.trailing, 5)
            }
        }
        .setupNavBarAndTitle("Feed")
        .lifecycle(viewModel)
    }
}

#Preview {
    FeedView(viewModel: .init(flowController: nil, signedInUser: ""))
}
