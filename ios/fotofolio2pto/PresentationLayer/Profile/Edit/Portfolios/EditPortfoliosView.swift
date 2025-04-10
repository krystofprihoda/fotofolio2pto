//
//  EditPortfoliosView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct EditPortfoliosView: View {
    
    @ObservedObject var viewModel: EditPortfoliosViewModel
    
    init(viewModel: EditPortfoliosViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.state.portfolios) { portfolio in
                VStack(alignment: .leading, spacing: Constants.Dimens.spaceMedium) {
                    Text(portfolio.name)
                        .font(.headline)
                        .padding(.leading, Constants.Dimens.spaceLarge)
                    
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
                            .padding(.leading, Constants.Dimens.spaceLarge)
                            
                            ForEach(portfolio.photos, id: \.id) { img in
                                ZStack {
                                    if case MyImageEnum.remote(let url) = img.src {
                                        AsyncImage(url: URL(string: url)!) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(
                                                    width: Constants.Dimens.frameSizeMediumLarge,
                                                    height: Constants.Dimens.frameSizeMediumLarge
                                                )
                                                .clipped()
                                                .cornerRadius(Constants.Dimens.radiusXSmall)
                                                .clipShape(
                                                    RoundedRectangle(
                                                        cornerRadius: Constants.Dimens.radiusXSmall
                                                    )
                                                )
                                        } placeholder: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                                    .fill(Color.gray).brightness(Constants.Dimens.opacityLow)
                                                    .aspectRatio(1.0, contentMode: .fit)
                                                    .frame(
                                                        width: Constants.Dimens.frameSizeMediumLarge,
                                                        height: Constants.Dimens.frameSizeMediumLarge
                                                    )
                                                    .skeleton(true)
                                            }
                                        }
                                    } else if case MyImageEnum.local(let image) = img.src {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(
                                                width: Constants.Dimens.frameSizeMediumLarge,
                                                height: Constants.Dimens.frameSizeMediumLarge
                                            )
                                            .clipped()
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
                    .frame(height: Constants.Dimens.frameSizeMediumLarge)
                }
            }
            
            Spacer()
        }
        .padding(.top, Constants.Dimens.spaceMedium)
        .toast(toastData: Binding(get: { viewModel.state.toastData }, set: { viewModel.onIntent(.setToastData($0)) }))
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { alertData in
                viewModel.onIntent(.onAlertDataChanged(alertData))
            }
        )) { alert in .init(alert) }
        .animation(.default, value: viewModel.state)
        .setupNavBarAndTitle(L.Profile.editPortfolios, hideBack: true)
        .navigationBarItems(leading: cancelButton)
    }
    
    private var cancelButton: some View {
        Button(action: { viewModel.onIntent(.cancel) }) {
            Text(L.General.back)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    EditPortfoliosView(viewModel: .init(flowController: nil, creatorId: "id", portfolios: []))
}
