//
//  SearchView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            // Search Bar
            ZStack(alignment: .trailing) {
                TextField(
                    L.Search.search,
                    text: Binding(
                        get: { viewModel.state.textInput },
                        set: { viewModel.onIntent(.setTextInput($0)) }
                    )
                )
                    .font(.body)
                    .padding()
                    .background(.textFieldBackground)
                    .frame(height: Constants.Dimens.textFieldHeight * Constants.Dimens.halfMultiplier)
                    .cornerRadius(Constants.Dimens.spaceSmall)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: viewModel.state.textInput) { _ in
                        viewModel.onIntent(.search)
                    }
                
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                    .padding(.trailing)
            }
            
            SearchResultsView(
                results: viewModel.state.searchResults,
                onResultTap: { user in viewModel.onIntent(.onResultTap(of: user)) }
            )
        }
        .padding([.horizontal, .top])
        .setupNavBarAndTitle(L.Search.title, hideBack: true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button(L.Profile.back) {
            viewModel.onIntent(.goBack)
        }
        .foregroundStyle(.black)
        .disabled(!viewModel.state.showDismiss)
        .opacity(viewModel.state.showDismiss ? 1 : 0)
    }
}

#Preview {
    SearchView(viewModel: .init(searchFlowController: nil, messagesFlowController: nil, signedInUserId: "", searchIntent: .profile))
}
