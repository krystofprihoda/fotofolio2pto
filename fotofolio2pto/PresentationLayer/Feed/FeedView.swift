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
                if viewModel.state.portfolios.isEmpty {
                    VStack(alignment: .center) {
                        if viewModel.state.isFiltering {
                            Text("Filtrování neodpovídá žádný výsledek.")
                                .foregroundColor(.red)
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    }
                    .frame(width: geo.size.width)
                    .frame(minHeight: geo.size.height)
                } else {
                    LazyVStack {
                        ForEach(viewModel.state.portfolios, id: \.id) { portfolio in
                            PortfolioView(
                                portfolio: portfolio,
                                mediaWidth: geo.size.width - Constants.Dimens.spaceXXLarge,
                                isFlagged: false,
                                flagAction: {},
                                unflagAction: {},
                                openProfileAction: {}
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
                Button("Filtrovat", action: {
                    viewModel.onIntent(.filter)
                })
                .padding(.trailing, 5)
            }
        }
        .setupNavBarAndTitle("Feed")
        .lifecycle(viewModel)
    }
}

#Preview {
    FeedView(viewModel: .init(flowController: nil))
}
