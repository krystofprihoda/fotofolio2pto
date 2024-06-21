//
//  PortfolioView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct PortfolioView: View {
    
    private let portfolio: Portfolio
    private let mediaWidth: CGFloat?
    
    init(
        portfolio: Portfolio,
        mediaWidth: CGFloat?
    ) {
        self.portfolio = portfolio
        self.mediaWidth = mediaWidth
    }
    
    var body: some View {
        VStack(spacing: Constants.Dimens.spaceMedium) {
            HStack {
                Button(action: {
                    // navigate to profile
                }, label: {
                    Text("@" + portfolio.authorUsername)
                        .font(.title2)
                        .foregroundColor(.pink)
                })
                
                Spacer()
                
                Button(action: {
                    // move to/from flagged
                }) {
//                    Image(systemName: portfolioViewModel.flagged.contains(portfolio) ? "bookmark.fill" : "bookmark")
                    Image(systemName: "bookmark")
                        .font(.title3)
//                        .foregroundColor(portfolioViewModel.flagged.contains(portfolio) ? .red : .gray)
                        .transition(.opacity)
                }
            }
            .padding([.leading, .trailing], Constants.Dimens.spaceLarge)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.Dimens.spaceMedium) {
                    ForEach(portfolio.photos) { photo in
                        if case MyImageEnum.remote(let url) = photo.src {
                            AsyncImage(url: URL(string: url)!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fill)
                                    .frame(width: mediaWidth)
                                    .cornerRadius(Constants.Dimens.radiusXSmall)
                            } placeholder: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                        .fill(Color.gray).brightness(0.25)
                                        .aspectRatio(1.0, contentMode: .fill)
                                        .frame(width: mediaWidth)

                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                }
                            }
                        } else if case MyImageEnum.local(let image) = photo.src {
                            image
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fill)
                                .frame(width: mediaWidth)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        }
                    }
                }
                .padding([.leading, .trailing], Constants.Dimens.spaceMedium)
            }
            .onTapGesture(count: 2) {
                // flag
            }
            
            HStack {
                Text(portfolio.description)
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
                Spacer()
            }
            .padding(.top, 5)
            .padding([.leading, .trailing, .bottom])
        }
        .transition(.opacity)
    }
}

#Preview {
    PortfolioView(portfolio: .dummyPortfolio1, mediaWidth: 350)
}
