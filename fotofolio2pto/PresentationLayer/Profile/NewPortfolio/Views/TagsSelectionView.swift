//
//  TagsSelectionView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 14.03.2025.
//

import SwiftUI

struct TagsSelectionView: View {
    @Binding private var searchText: String
    private var selectedTags: [String]
    private var filteredTags: [String]
    private var onAddToSelectedTags: (String) -> Void
    private var onRemoveFromSelectedTags: (String) -> Void
    
    init(
        searchText: Binding<String>,
        selectedTags: [String],
        filteredTags: [String],
        onAddToSelectedTags: @escaping (String) -> Void,
        onRemoveFromSelectedTags: @escaping (String) -> Void
    ) {
        self._searchText = searchText
        self.selectedTags = selectedTags
        self.filteredTags = filteredTags
        self.onAddToSelectedTags = onAddToSelectedTags
        self.onRemoveFromSelectedTags = onRemoveFromSelectedTags
    }
    
    var body: some View {
        VStack(spacing: Constants.Dimens.spaceMedium) {
            // Search Bar
            TextField(L.Profile.portraitsExample, text: $searchText)
                .font(.body)
                .padding()
                .background(.textFieldBackground)
                .frame(height: Constants.Dimens.textFieldHeight * Constants.Dimens.halfMultiplier)
                .cornerRadius(Constants.Dimens.spaceSmall)
                .padding(.trailing)

            // Tags
            VStack {
                ForEach(filteredTags.chunked(into: 5), id: \.self) { row in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(row, id: \.self) { category in
                                let isSelected = selectedTags.contains(where: { $0 == category })
                                Button(action: { isSelected ? onRemoveFromSelectedTags(category) : onAddToSelectedTags(category) }, label: {
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
