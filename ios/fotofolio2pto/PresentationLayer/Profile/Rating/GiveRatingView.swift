//
//  GiveRatingView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 07.04.2025.
//

import SwiftUI

struct GiveRatingView: View {
    
    @ObservedObject var viewModel: GiveRatingViewModel
    
    init(viewModel: GiveRatingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: Constants.Dimens.spaceLarge) {
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: Constants.Dimens.frameSizeXSmall * Constants.Dimens.halfMultiplier)
                        .foregroundColor(index + 1 > viewModel.state.rating ? .gray : .yellow)
                        .onTapGesture { viewModel.onIntent(.setRating(index + 1)) }
                }
            }
            
            Button(action: { viewModel.onIntent(.giveRating) }, label: {
                Text(L.Profile.giveRating)
                    .font(.body)
                    .frame(height: Constants.Dimens.textFieldHeight/2)
                    .frame(maxWidth: .infinity)
                    .padding(Constants.Dimens.spaceLarge)
                    .foregroundStyle(.white)
                    .background(.mainAccent)
                    .cornerRadius(Constants.Dimens.radiusXSmall)
            })
            .padding(.horizontal, Constants.Dimens.spaceXLarge)
        }
        .toast(toastData: Binding(get: { viewModel.state.toastData }, set: { viewModel.onIntent(.setToastData($0)) }))
        .navigationBarItems(leading: backButton)
        .setupNavBarAndTitle(L.Profile.rating, hideBack: true)
    }
    
    var backButton: some View {
        Button(L.General.back) {
            viewModel.onIntent(.goBack)
        }
        .foregroundStyle(.black)
    }
}
