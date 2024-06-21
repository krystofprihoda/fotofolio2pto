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
    
    @AppStorage("username") var username: String = "default"
    @State private var clearSelection = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                if !viewModel.state.portfolios.isEmpty {
                    ForEach(viewModel.state.portfolios, id: \.id) { portfolio in
                        PortfolioDetailView(mediaWidth: geo.size.width, portfolio: portfolio)
                    }
                } else {
                    Text("Není co zobrazovat, vyberte si portfolia ve Feedu!")
                        .frame(width: geo.size.width, height: geo.size.height)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !viewModel.state.portfolios.isEmpty {
                    Button(action: {
                        // clearSelection
                    }) {
                        Text("Odstranit vše")
                    }
                    .padding(.trailing, 5)
                }
            }
        }
        .setupNavBarAndTitle("Výběr")
        .alert("Opravdu chcete odstranit všechna portfolia ze svého výběru?", isPresented: $clearSelection) {
            Button("Ano") {
//                portfolioViewModel.clearFlagged()
            }
            
            Button("Ne") { }
        }
    }
}

#Preview {
    SelectionView(viewModel: .init(flowController: nil))
}
