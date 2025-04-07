//
//  ProfilePortfoliosView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import SwiftUI

struct ProfilePortfoliosView: View {
    private let portfolios: [Portfolio]
    
    @State private var showText: Bool = false
    
    init(portfolios: [Portfolio]) {
        self.portfolios = portfolios
    }
    
    var body: some View {
        if portfolios.isEmpty {
            Text("Uživatel zatím nenahrál žádná portfolia.")
                .foregroundColor(.gray)
                .font(.body)
        } else {
            VStack(spacing: Constants.Dimens.spaceNone) {
                ForEach(portfolios, id: \.id) { portfolio in
                    VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
                        if showText {
                            HStack {
                                Text(portfolio.name)
                                    .font(.headline)
                                    .padding(.bottom, Constants.Dimens.spaceSmall)
                                    .padding([.leading, .trailing], Constants.Dimens.spaceXLarge)
                                    .foregroundColor(.black)
                                    .brightness(Constants.Dimens.opacityLow)
                                    .transition(.opacity)

                                Spacer()
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Constants.Dimens.spaceMedium) {
                                ForEach(portfolio.photos) { photo in
                                    if case MyImageEnum.remote(let url) = photo.src {
                                        AsyncImage(url: URL(string: url)!) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: Constants.Dimens.frameSizeXLarge, height: Constants.Dimens.frameSizeXLarge)
                                                .clipped()
                                                .cornerRadius(Constants.Dimens.radiusXSmall)
                                        } placeholder: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                                    .fill(.gray)
                                                    .brightness(Double.random(in: Constants.Dimens.opacityLowLow...Constants.Dimens.opacityLow))
                                                    .aspectRatio(1.0, contentMode: .fit)
                                                    .frame(width: Constants.Dimens.frameSizeXLarge)

                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle())
                                            }
                                        }
                                    }
                                }
                            }
                            .padding([.leading, .trailing, .bottom], Constants.Dimens.spaceMedium)
                        }
                        
                        if showText {
                            Text(portfolio.description)
                                .font(.body)
                                .padding([.leading, .trailing], Constants.Dimens.spaceXLarge)
                                .padding(.bottom, Constants.Dimens.spaceXSmall)
                                .foregroundColor(.gray).brightness(Constants.Dimens.opacityLowLow)
                                .transition(.opacity)
                            
                            Divider()
                                .padding([.leading, .trailing], Constants.Dimens.spaceXLarge)
                                .padding([.top, .bottom], Constants.Dimens.spaceSmall)
                        }
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    showText.toggle()
                }
            }
        }
    }
}

#Preview {
    ProfilePortfoliosView(portfolios: [])
}
