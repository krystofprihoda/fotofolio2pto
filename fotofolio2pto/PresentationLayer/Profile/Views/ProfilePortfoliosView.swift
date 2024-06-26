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
                .font(.system(size: 16))
        } else {
            VStack(spacing: Constants.Dimens.spaceNone) {
                ForEach(portfolios, id: \.id) { portfolio in
                    VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
                        if showText {
                            HStack {
                                Text(portfolio.name)
                                    .font(.system(size: 20))
                                    .padding([.top, .bottom], Constants.Dimens.spaceSmall)
                                    .padding([.leading, .trailing], Constants.Dimens.spaceXLarge)
                                    .foregroundColor(.black).brightness(0.3)
                                    .transition(.opacity)

                                Spacer()
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Constants.Dimens.spaceMedium) {
                                ForEach(portfolio.photos) { photo in
                                    if case MyImageEnum.remote(let url) = photo.src {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(1.0, contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(Constants.Dimens.radiusXSmall)
                                        } placeholder: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                                    .fill(.gray)
                                                    .brightness(Double.random(in: 0.15...0.4))
                                                    .aspectRatio(1.0, contentMode: .fit)
                                                    .frame(width: 150, height: 150)

                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle())
                                            }
                                        }
                                    } else if case MyImageEnum.local(let image) = photo.src {
                                        image
                                            .resizable()
                                            .aspectRatio(1.0, contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(Constants.Dimens.radiusXSmall)
                                    }
                                }
                            }
                            .padding([.leading, .trailing], Constants.Dimens.spaceMedium)
                            .padding(.bottom, Constants.Dimens.spaceMedium)
                        }
                        
                        if showText {
                            Text(portfolio.description)
                                .font(.system(size: 15))
                                .padding(.top, Constants.Dimens.spaceXSmall)
                                .padding([.leading, .trailing], Constants.Dimens.spaceXLarge)
                                .padding(.bottom, Constants.Dimens.spaceXSmall)
                                .foregroundColor(.gray).brightness(0.1)
                                .transition(.opacity)
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
    ProfilePortfoliosView(portfolios: [.dummyPortfolio1])
}
