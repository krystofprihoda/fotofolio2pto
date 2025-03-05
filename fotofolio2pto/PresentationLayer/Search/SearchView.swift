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
            Picker(
                L.Search.searchBy,
                selection: Binding(
                    get: { viewModel.state.searchOption },
                    set: { viewModel.onIntent(.setSearchOption($0)) }
                )
            ) {
                ForEach(SearchOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.top)
            
            ZStack {
                Rectangle()
                   .foregroundColor(.gray).brightness(0.37)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField(
                        L.Search.search,
                        text: Binding(
                            get: { viewModel.state.textInput },
                            set: { viewModel.onIntent(.setTextInput($0)) }
                        )
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: viewModel.state.textInput) { _ in
                        viewModel.onIntent(.search)
                    }
                }
                .padding()
             }
            .frame(height: 45)
            .cornerRadius(Constants.Dimens.radiusXSmall)
            
            SearchResultsView(results: viewModel.state.searchResults, showProfile: { user in viewModel.onIntent(.showProfile(of: user))})
        }
        .padding([.leading, .trailing])
        .setupNavBarAndTitle(L.Search.title)
    }
}

#Preview {
    SearchView(viewModel: .init(flowController: nil, signedInUser: ""))
}
