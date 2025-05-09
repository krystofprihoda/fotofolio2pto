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
                                            .fill(.mainContrast)
                                            .opacity(Constants.Dimens.opacityMid)
                                            .frame(
                                                width: Constants.Dimens.frameSizeSmall,
                                                height: Constants.Dimens.frameSizeSmall
                                            )
                                        
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
                                PhotoView(image: img.src, size: Constants.Dimens.frameSizeMediumLarge)
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
