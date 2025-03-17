//
//  SearchView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject private var viewModel: SearchViewModel
    @State private var tmpToast: ToastData = .init()
    
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
            
            VStack {
                Button("Show Toast") {
                    tmpToast = .init(message: "Toastik hej co je co je ses posral asi zes tohle udelal nee", type: .error)
                }
            }
            
            SearchResultsView(
                results: viewModel.state.searchResults,
                showProfile: { user in viewModel.onIntent(
                    .showProfile(of: user)
                )}
            )
        }
        .toast(toastData: $tmpToast)
        .padding([.horizontal, .top])
        .setupNavBarAndTitle(L.Search.title)
    }
}

#Preview {
    SearchView(viewModel: .init(flowController: nil, signedInUser: ""))
}
