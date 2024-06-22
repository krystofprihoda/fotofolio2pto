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
        ScrollView {
            VStack {
                Picker("Vyhledávat podle", selection: Binding(get: { viewModel.state.searchOption }, set: { viewModel.onIntent(.setSearchOption($0)) })) {
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
                            "Hledat",
                            text: Binding(
                                    get: { viewModel.state.textInput },
                                    set: { viewModel.onIntent(.setTextInput($0)) }
                            )
                        ) { editing in
                            if editing {
                                viewModel.onIntent(.setIsSearching(true))
                            }
                        } onCommit: {
                            viewModel.onIntent(.setIsSearching(false))
                        }
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    }
                    .padding()
                 }
                .frame(height: 45)
                .cornerRadius(10)
                
                SearchResultsView(results: viewModel.state.searchResults)
            }
        }
        .padding([.leading, .trailing])
        .toolbar {
//            if searchViewModel.searching {
//                Button("Zrušit") {
//                    searchViewModel.searchString = ""
//                    searchViewModel.searching = false
//                    
//                    UIApplication.shared.dismissKeyboard()
//                }
//                .transition(.opacity)
//            }
        }
//        .onChange(of: searchViewModel.searchString, perform: { _ in
//            withAnimation {
//                searchViewModel.searchedUsers = searchViewModel.fetchUsersBySubstring(input: searchViewModel.searchString, mode: searchViewModel.searchMode)
//            }
//        })
        .setupNavBarAndTitle("Vyhledávání")
    }
}

#Preview {
    SearchView(viewModel: .init(flowController: nil))
}
