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
            VStack {
                ForEach(portfolios, id: \.id) { portfolio in
                    VStack(alignment: .leading) {
                        if showText {
                            HStack {
                                Text(portfolio.name)
                                    .font(.system(size: 20))
                                    .padding(.top, 5)
                                    .padding(.leading, 25)
                                    .foregroundColor(.black).brightness(0.3)
                                    .transition(.opacity)

                                Spacer()
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(portfolio.photos, id: \.id) { photo in
                                    let last = portfolio.photos.last!.id == photo.id
                                    
                                    if case MyImageEnum.remote(let url) = photo.src {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(1.0, contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(CGFloat(9))
                                                .padding(.leading, 5)
                                                .padding(.trailing, last ? 10 : 0)
                                        } placeholder: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 9)
                                                    .fill(Color.gray).brightness(0.25)
                                                    .aspectRatio(1.0, contentMode: .fit)
                                                    .frame(width: 150, height: 150)
                                                    .padding(.leading, 5)
                                                    .padding(.trailing, last ? 10 : 0)

                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle())
                                            }
                                        }
                                    } else if case MyImageEnum.local(let image) = photo.src {
                                        image
                                            .resizable()
                                            .aspectRatio(1.0, contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(CGFloat(9))
                                            .padding(.leading, 5)
                                            .padding(.trailing, last ? 10 : 0)
                                    }
                                }
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.bottom, 5)
                        
                        if showText {
                            Text(portfolio.description)
                                .font(.system(size: 15))
                                .padding(.top, 5)
                                .padding(.leading, 25)
                                .padding(.trailing, 21)
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
