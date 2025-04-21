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
            Text(L.Profile.noPortfoliosUploaded)
                .foregroundColor(.mainText)
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
                                    .foregroundColor(.main)
                                    .transition(.opacity)

                                Spacer()
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Constants.Dimens.spaceMedium) {
                                ForEach(portfolio.photos) { photo in
                                    PhotoView(image: photo.src, size: Constants.Dimens.frameSizeXLarge)
                                }
                            }
                            .padding([.leading, .trailing, .bottom], Constants.Dimens.spaceMedium)
                        }
                        
                        if showText {
                            Text(portfolio.description)
                                .font(.body)
                                .padding([.leading, .trailing], Constants.Dimens.spaceXLarge)
                                .padding(.bottom, Constants.Dimens.spaceXSmall)
                                .foregroundColor(.main)
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
