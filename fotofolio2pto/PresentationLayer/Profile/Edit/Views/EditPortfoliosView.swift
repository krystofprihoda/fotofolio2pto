//
//  EditPortfoliosView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct EditPortfoliosView: View {
    
    @ObservedObject var viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(L.Profile.portfolios)
                .font(.footnote)
                .foregroundColor(.black)
                .padding(.leading)
            
            ForEach(viewModel.state.portfolios) { portfolio in
                VStack(alignment: .leading) {
                    Text(portfolio.name)
                        .font(.body)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            VStack {
                                Button(action: {
                                    viewModel.onIntent(.editPorfolio(portfolio))
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                            .fill(.textFieldBackground)
                                            .frame(
                                                width: Constants.Dimens.frameSizeSmall,
                                                height: Constants.Dimens.frameSizeSmall
                                            )
                                        
                                        Image(systemName: "pencil")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(
                                                width: Constants.Dimens.frameSizeXSmall,
                                                height: Constants.Dimens.frameSizeXSmall
                                            )
                                            .foregroundColor(.black)
                                    }
                                }
                                
                                Button(action: {
                                    viewModel.onIntent(.removePortfolio(portfolio.id))
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                            .fill(.pink)
                                            .frame(
                                                width: Constants.Dimens.frameSizeSmall,
                                                height: Constants.Dimens.frameSizeSmall
                                            )
                                            .opacity(Constants.Dimens.opacityLow)
                                        
                                        Image(systemName: "trash")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(
                                                width: Constants.Dimens.frameSizeXSmall,
                                                height: Constants.Dimens.frameSizeXSmall
                                            )
                                            .foregroundColor(.red)
                                    }
                                })
                            }
                            .padding(.leading)
                            
                            ForEach(portfolio.photos, id: \.id) { img in
                                ZStack {
                                    if case MyImageEnum.remote(let url) = img.src {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(1.0, contentMode: .fill)
                                                .frame(
                                                    width: Constants.Dimens.frameSizeMediumLarge,
                                                    height: Constants.Dimens.frameSizeMediumLarge
                                                )
                                                .cornerRadius(Constants.Dimens.radiusXSmall)
                                                .clipShape(
                                                    RoundedRectangle(
                                                        cornerRadius: Constants.Dimens.radiusXSmall
                                                    )
                                                )
                                        } placeholder: {
                                            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                                .fill(Color.gray).brightness(0.25)
                                                .aspectRatio(1.0, contentMode: .fit)
                                                .frame(
                                                    width: Constants.Dimens.frameSizeMediumLarge,
                                                    height: Constants.Dimens.frameSizeMediumLarge
                                                )
                                        }
                                    } else if case MyImageEnum.local(let image) = img.src {
                                        image
                                            .resizable()
                                            .aspectRatio(1.0, contentMode: .fill)
                                            .frame(
                                                width: Constants.Dimens.frameSizeMediumLarge,
                                                height: Constants.Dimens.frameSizeMediumLarge
                                            )
                                            .cornerRadius(Constants.Dimens.radiusXSmall)
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: Constants.Dimens.radiusXSmall
                                                )
                                            )
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
        }
        .animation(.default, value: viewModel.state)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EditPortfoliosView(viewModel: .init(flowController: nil, userData: .dummy1, portfolios: [.dummyPortfolio2]))
}
