//
//  NewPortfolioView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct NewPortfolioView: View {
    
    @ObservedObject var viewModel: NewPortfolioViewModel
    
    init(viewModel: NewPortfolioViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.Dimens.spaceSmall) {
                // Name
                VStack(alignment: .leading, spacing: Constants.Dimens.spaceSmall) {
                    Text(L.Profile.titleName)
                        .font(.body)
                        .bold()
                    
                    TextField(
                        L.Profile.portraitsExample,
                        text: Binding(
                            get: { viewModel.state.name },
                            set: { input in viewModel.onIntent(.setName(input)) }
                        )
                    )
                    .font(.body)
                    .frame(height: Constants.Dimens.textFieldHeight)
                    .padding()
                    .background(.textFieldBackground)
                    .cornerRadius(Constants.Dimens.radiusXSmall)
                }
                .padding(.horizontal)
                
                Text(L.Profile.photography)
                    .font(.body)
                    .bold()
                    .padding(.leading)
                
                // Photos
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        Button(action: { viewModel.onIntent(.pickMedia) }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(.textFieldBackground)
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: Constants.Dimens.frameSizeXSmall, height: Constants.Dimens.frameSizeXSmall)
                                    .foregroundColor(.black)
                                    .opacity(Constants.Dimens.opacityMid)
                            }
                        }
                        .padding(.leading)
                        
                        if viewModel.state.media.isEmpty {
                            ForEach(0..<2) { i in
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(.textFieldBackground)
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                                    .opacity(i == 0 ? Constants.Dimens.opacityMid : Constants.Dimens.opacityLow)
                            }
                        } else {
                            ForEach(viewModel.state.media) { iimg in
                                ZStack(alignment: .topTrailing) {
                                    if case MyImageEnum.local(let image) = iimg.src {
                                        image
                                            .resizable()
                                            .aspectRatio(1.0, contentMode: .fill)
                                            .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                                            .cornerRadius(Constants.Dimens.radiusXSmall)
                                    } else {
                                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                            .fill(.red)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                                            .opacity(Constants.Dimens.opacityMid)
                                    }
                                    
                                    Button(action: {}) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                                .fill(.gray)
                                                .aspectRatio(1.0, contentMode: .fit)
                                                .frame(width: Constants.Dimens.frameSizeSmall, height: Constants.Dimens.frameSizeSmall)
                                                .opacity(Constants.Dimens.opacityMid)
                                            
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: Constants.Dimens.spaceSemiMedium, height: Constants.Dimens.spaceSemiMedium)
                                                .foregroundColor(.red)
                                                .opacity(Constants.Dimens.opacityHigh)
                                                .padding()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Description
                VStack(alignment: .leading, spacing: Constants.Dimens.spaceSmall) {
                    Text(L.Profile.shortDescription)
                        .font(.body)
                        .bold()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                            .fill(.textFieldBackground)
                            .frame(height: Constants.Dimens.frameSizeLarge)
                        
                        TextEditor(text: Binding(get: { viewModel.state.description }, set: { viewModel.onIntent(.setDescriptionInput($0)) }))
                            .font(.body)
                            .frame(height: Constants.Dimens.frameSizeLarge)
                            .lineSpacing(Constants.Dimens.spaceXSmall)
                            .foregroundColor(.gray)
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                            .offset(
                                x: Constants.Dimens.spaceSmall,
                                y: Constants.Dimens.spaceXSmall
                            )
                    }
                }
                .padding(.horizontal)
                
                // Tags
                VStack(alignment: .leading, spacing: Constants.Dimens.spaceSmall) {
                    Text(L.Profile.maxNumberOfTags)
                        .font(.body)
                        .bold()
                    
                    TagsSelectionView()
                }
                .padding(.leading)
            }
            .padding(.top, Constants.Dimens.spaceSmall)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.onIntent(.close)
                }) {
                    Text(L.Profile.cancel)
                }
                .foregroundColor(.gray)
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.onIntent(.createNewPortfolio)
                }) {
                    if viewModel.state.isLoading {
                        ProgressView().progressViewStyle(.circular)
                    } else {
                        Text(L.Profile.createNew)
                    }
                }
                .foregroundColor(.gray)
            }
        }
        .lifecycle(viewModel)
        .navigationBarBackButtonHidden(true)
        .setupNavBarAndTitle(L.Profile.newPortfolioTitle)
    }
}

#Preview {
    NewPortfolioView(viewModel: .init(flowController: nil, userData: .dummy1))
}

struct TagsSelectionView: View {
    var body: some View {
        VStack {
            ForEach(photoCategories.chunked(into: 4), id: \.self) { row in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(row, id: \.self) { category in
                            Text(category)
                                .font(.footnote)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding()
                                .background(.mainAccent)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                )
                        }
                    }
                }
            }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
