//
//  EditPortfolioView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct EditPortfolioView: View {
    
    @ObservedObject var viewModel: EditPortfolioViewModel
    
    init(viewModel: EditPortfolioViewModel) {
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
                        if viewModel.state.media.isEmpty {
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
                            
                            ForEach(0..<2) { i in
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(.textFieldBackground)
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                                    .opacity(i == 0 ? Constants.Dimens.opacityMid : Constants.Dimens.opacityLow)
                            }
                        } else {
                            ForEach(Array(zip(viewModel.state.media.indices, viewModel.state.media)), id: \.0) { idx, iimg in
                                ZStack(alignment: .topTrailing) {
                                    if case MyImageEnum.local(let image) = iimg.src {
                                        image
                                            .resizable()
                                            .aspectRatio(1.0, contentMode: .fill)
                                            .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                                            .cornerRadius(Constants.Dimens.radiusXSmall)
                                            .padding(.leading, idx == 0 ? Constants.Dimens.spaceLarge : Constants.Dimens.spaceNone)
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
                                                .fill(.white)
                                                .aspectRatio(1.0, contentMode: .fit)
                                                .frame(width: Constants.Dimens.frameSizeSmall, height: Constants.Dimens.frameSizeSmall)
                                                .opacity(Constants.Dimens.opacityMid)
                                            
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: Constants.Dimens.spaceLarge, height: Constants.Dimens.spaceLarge)
                                                .foregroundColor(.red)
                                                .opacity(Constants.Dimens.opacityHigh)
                                                .padding()
                                        }
                                        .padding(Constants.Dimens.spaceXSmall)
                                    }
                                }
                            }
                            
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
                            .padding(.trailing)
                        }
                    }
                }
                .frame(height: Constants.Dimens.frameSizeXXLarge)
                
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
                    
                    TagsSelectionView(
                        searchText: Binding(
                            get: { viewModel.state.searchInput },
                            set: { viewModel.onIntent(.setTagInput($0)) }
                        ),
                        selectedTags: viewModel.state.selectedTags,
                        filteredTags: viewModel.state.filteredTags,
                        onAddToSelectedTags: { viewModel.onIntent(.addTag($0)) },
                        onRemoveFromSelectedTags: { viewModel.onIntent(.removeTag($0)) }
                    )
                }
                .padding(.leading)
            }
            .padding(.top, Constants.Dimens.spaceSmall)
        }
        .lifecycle(viewModel)
        .animation(.default, value: viewModel.state)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.onIntent(.close)
                }) {
                    Text(L.Profile.cancel)
                }
                .foregroundColor(.black)
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.onIntent(.createNewPortfolio)
                }) {
                    if viewModel.state.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Text(L.Profile.createNew)
                    }
                }
                .foregroundColor(viewModel.state.isCreateButtonDisabled ? .gray : .black)
                .disabled(viewModel.state.isCreateButtonDisabled)
            }
        }
        .navigationBarBackButtonHidden(true)
        .setupNavBarAndTitle(L.Profile.newPortfolioTitle)
    }
}

#Preview {
    EditPortfolioView(viewModel: .init(flowController: nil, portfolioAuthorUsername: "author"))
}
