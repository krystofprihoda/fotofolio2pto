//
//  SelectionView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct SelectionView: View {
    
    @ObservedObject private var viewModel: SelectionViewModel
    
    init(viewModel: SelectionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    if viewModel.state.isLoading {
                        VStack(alignment: .center) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    } else if !viewModel.state.portfolios.isEmpty {
                        ForEach(viewModel.state.portfolios, id: \.id) { portfolio in
                            PortfolioDetailView(
                                mediaWidth: geo.size.width,
                                portfolio: portfolio,
                                unflagPortfolio: { viewModel.onIntent(.tapRemoveFromFlagged(portfolio.id)) },
                                showProfile: { viewModel.onIntent(.showProfile(portfolio.author)) },
                                sendMessage: { viewModel.onIntent(.sendMessage(to: portfolio.author)) }
                            )
                        }
                    } else {
                        Text(L.Selection.emptySelection)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !viewModel.state.portfolios.isEmpty {
                    Button(L.Selection.removeAll) {
                        viewModel.onIntent(.tapRemoveAllFlagged)
                    }
                    .padding(.trailing, 5)
                }
            }
        }
        .setupNavBarAndTitle(L.Selection.title)
        .animation(.default, value: viewModel.state.portfolios)
        .lifecycle(viewModel)
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { alertData in
                viewModel.onIntent(.onAlertDataChanged(alertData))
            }
        )) { alert in .init(alert) }
    }
}

#Preview {
    SelectionView(viewModel: .init(flowController: nil))
}
