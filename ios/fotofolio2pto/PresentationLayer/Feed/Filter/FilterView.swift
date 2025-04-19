//
//  FilterView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct FilterView: View {
    
    @ObservedObject private var viewModel: FilterViewModel
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Constants.Dimens.spaceNone) {
                ZStack {
                    Text(L.Feed.filterPortfolios)
                        .fontWeight(.medium)
                    
                    HStack {
                        Spacer()
                        Button(action: { viewModel.onIntent(.dismiss) }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: Constants.Dimens.spaceLarge)
                                .foregroundColor(.mainContrast)
                        }
                        .padding(Constants.Dimens.spaceLarge)
                    }
                }
                .padding(Constants.Dimens.spaceMedium)
                
                /// Categories
                CategorySelectionView(
                    searchText: Binding(
                        get: { viewModel.state.searchInput },
                        set: { viewModel.onIntent(.setSearchInput($0))}
                    ),
                    selectedCategories: viewModel.state.selectedCategories,
                    filteredCategories: viewModel.state.filteredCategories,
                    onAddToSelectedCategories: { category in
                        viewModel.onIntent(.addCategory(category))
                    },
                    onRemoveFromSelectedCategories: { category in
                        viewModel.onIntent(.removeCategory(category))
                    })
                
                Spacer()
            }
            .padding([.leading, .top], Constants.Dimens.spaceLarge)
        }
    }
}
#Preview {
    FilterView(viewModel: .init(flowController: nil))
}
