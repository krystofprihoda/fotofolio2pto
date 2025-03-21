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
                                .foregroundColor(.red).brightness(0.2)
                        }
                        .padding()
                    }
                }
                .padding(Constants.Dimens.spaceMedium)
                
                /// Tags
                TagsSelectionView(
                    searchText: Binding(
                        get: { viewModel.state.searchInput },
                        set: { viewModel.onIntent(.setSearchInput($0))}
                    ),
                    selectedTags: viewModel.state.selectedTags,
                    filteredTags: viewModel.state.filteredTags,
                    onAddToSelectedTags: { tag in
                        viewModel.onIntent(.addTag(tag))
                    },
                    onRemoveFromSelectedTags: { tag in
                        viewModel.onIntent(.removeTag(tag))
                    })
                
                Spacer()
            }
            .padding([.leading, .top])
        }
    }
}
#Preview {
    FilterView(viewModel: .init(flowController: nil))
}
