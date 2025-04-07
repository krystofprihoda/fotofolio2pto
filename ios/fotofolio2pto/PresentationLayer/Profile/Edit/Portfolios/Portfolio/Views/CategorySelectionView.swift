//
//  CategorySelectionView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 14.03.2025.
//

import SwiftUI

struct CategorySelectionView: View {
    @Binding private var searchText: String
    private var selectedCategories: [String]
    private var filteredCategories: [String]
    private var onAddToSelectedCategories: (String) -> Void
    private var onRemoveFromSelectedCategories: (String) -> Void
    
    init(
        searchText: Binding<String>,
        selectedCategories: [String],
        filteredCategories: [String],
        onAddToSelectedCategories: @escaping (String) -> Void,
        onRemoveFromSelectedCategories: @escaping (String) -> Void
    ) {
        self._searchText = searchText
        self.selectedCategories = selectedCategories
        self.filteredCategories = filteredCategories
        self.onAddToSelectedCategories = onAddToSelectedCategories
        self.onRemoveFromSelectedCategories = onRemoveFromSelectedCategories
    }
    var body: some View {
        VStack(spacing: Constants.Dimens.spaceMedium) {
            // Search Bar
            ZStack(alignment: .trailing) {
                TextField(L.Profile.portraitsExample, text: $searchText)
                    .font(.body)
                    .padding()
                    .background(.textFieldBackground)
                    .frame(height: Constants.Dimens.textFieldHeight * Constants.Dimens.halfMultiplier)
                    .cornerRadius(Constants.Dimens.spaceSmall)
                
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                    .padding(.trailing)
            }
            .padding(.trailing)

            // Tags
            VStack {
                ForEach(filteredCategories.chunked(into: 5), id: \.self) { row in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(row, id: \.self) { category in
                                let isSelected = selectedCategories.contains(where: { $0 == category })
                                Button(action: { isSelected ? onRemoveFromSelectedCategories(category) : onAddToSelectedCategories(category) }, label: {
                                    HStack {
                                        Text(category)
                                            .font(.footnote)
                                            .fixedSize(horizontal: true, vertical: false)
                                            .foregroundColor(isSelected ? .white : .black)
                                        
                                        if isSelected {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: Constants.Dimens.spaceSmall, height: Constants.Dimens.spaceSmall)
                                                .foregroundColor(.white)
                                                .padding(.leading, Constants.Dimens.spaceXXSmall)
                                        }
                                    }
                                    .padding()
                                    .background(isSelected ? Color.mainAccent : Color.textFieldBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall))
                                })
                            }
                        }
                    }
                }
            }
        }
    }
}
