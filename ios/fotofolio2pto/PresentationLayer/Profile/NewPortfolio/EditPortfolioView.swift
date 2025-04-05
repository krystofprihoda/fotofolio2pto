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
                photosScrollView
                
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
                            .foregroundColor(.black)
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                            .offset(
                                x: Constants.Dimens.spaceSmall,
                                y: Constants.Dimens.spaceXSmall
                            )
                    }
                }
                .padding(.horizontal)
                
                // Category
                VStack(alignment: .leading, spacing: Constants.Dimens.spaceSmall) {
                    Text(L.Profile.maxNumberOfTags)
                        .font(.body)
                        .bold()
                    
                    CategorySelectionView(
                        searchText: Binding(
                            get: { viewModel.state.searchInput },
                            set: { viewModel.onIntent(.setCategoryInput($0)) }
                        ),
                        selectedCategories: viewModel.state.selectedCategories,
                        filteredCategories: viewModel.state.filteredCategories,
                        onAddToSelectedCategories: { viewModel.onIntent(.addCategory($0)) },
                        onRemoveFromSelectedCategories: { viewModel.onIntent(.removeCategory($0)) }
                    )
                }
                .padding(.leading)
            }
            .padding(.top, Constants.Dimens.spaceSmall)
        }
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { alertData in
                viewModel.onIntent(.onAlertDataChanged(alertData))
            }
        )) { alert in .init(alert) }
        .lifecycle(viewModel)
        .animation(.default, value: viewModel.state)
        .navigationBarItems(leading: cancelButton, trailing: saveButton)
        .setupNavBarAndTitle(
            viewModel.state.portfolioIntent == .createNew ? L.Profile.newPortfolioTitle : viewModel.state.name,
            hideBack: true
        )
    }
    
    var photosScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Constants.Dimens.spaceSemiMedium) {
                if viewModel.state.media.isEmpty {
                    if viewModel.state.portfolioIntent == .createNew {
                        Button(action: { viewModel.onIntent(.pickMedia) }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(.textFieldBackground)
                                    .aspectRatio(1.0, contentMode: .fill)
                                    .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: Constants.Dimens.frameSizeXSmall, height: Constants.Dimens.frameSizeXSmall)
                                    .foregroundColor(.black)
                                    .opacity(Constants.Dimens.opacityMid)
                            }
                        }
                    }
                    
                    ForEach(0..<2) { i in
                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                            .fill(.textFieldBackground)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                            .opacity(i == 0 ? Constants.Dimens.opacityMid : Constants.Dimens.opacityLow)
                    }
                } else {
                    ForEach(Array(zip(viewModel.state.media.indices, viewModel.state.media)), id: \.0) { idx, iimg in
                        ZStack(alignment: .topTrailing) {
                            if case MyImageEnum.local(let image) = iimg.src {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                                    .clipped()
                                    .cornerRadius(Constants.Dimens.radiusXSmall)
                            } else if case MyImageEnum.remote(let url) = iimg.src {
                                AsyncImage(url: URL(string: url)!) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)
                                        .clipped()
                                        .cornerRadius(Constants.Dimens.radiusXSmall)
                                } placeholder: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                            .fill(.gray)
                                            .brightness(Double.random(in: 0.15...0.4))
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: Constants.Dimens.frameSizeXXLarge, height: Constants.Dimens.frameSizeXXLarge)

                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                    }
                                }
                            }
                            
                            // Portfolio must have at least one photo,
                            if viewModel.state.media.count > 1 || viewModel.state.portfolioIntent == .createNew {
                                Button(action: { viewModel.onIntent(.removePic(iimg.id)) }) {
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
                                            .padding(Constants.Dimens.spaceXLarge)
                                    }
                                }
                            }
                        }
                    }
                    
                    if viewModel.state.portfolioIntent == .createNew {
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
                        .padding(.trailing, Constants.Dimens.spaceLarge)
                    }
                }
            }
            .padding(.horizontal, Constants.Dimens.spaceLarge)
        }
        .frame(height: Constants.Dimens.frameSizeXXLarge)
    }
    
    var cancelButton: some View {
        Button(action: {
            viewModel.onIntent(.close)
        }) {
            Text(L.Profile.cancel)
        }
        .foregroundColor(.black)
    }
    
    var saveButton: some View {
        Button(action: {
            viewModel.onIntent(.saveChanges)
        }) {
            if viewModel.state.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Text(
                    viewModel.state.portfolioIntent == .createNew ? L.Profile.createNew : L.Profile.save
                )
            }
        }
        .foregroundColor(viewModel.state.isSaveButtonDisabled ? .gray : .black)
        .disabled(viewModel.state.isSaveButtonDisabled)
    }
}

#Preview {
    EditPortfolioView(viewModel: .init(flowController: nil, creatorId: "creatorId"))
}
