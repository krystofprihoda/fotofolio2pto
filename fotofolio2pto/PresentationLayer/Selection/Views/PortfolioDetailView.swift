//
//  PortfolioDetailView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct PortfolioDetailView: View {
    
    private let mediaWidth: CGFloat?
    private let portfolio: Portfolio
    
    init(
        mediaWidth: CGFloat?,
        portfolio: Portfolio
    ) {
        self.mediaWidth = mediaWidth
        self.portfolio = portfolio
    }
    
    var body: some View {
        VStack {
            /// Folio Author
            AuthorDetailView(author: portfolio.author)
            
            /// Carousel
            PhotoCarouselView(mediaWidth: mediaWidth, photos: portfolio.photos)
            
            /// Description
            HStack {
                Text(portfolio.description)
                    .font(.system(size: 16))
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
                Spacer()
            }
            .padding(.top, 5)
            .padding(.leading, 21)
            .padding(.trailing, 21)
        }
        .padding(.bottom, 10)
        .alert("Opravdu chcete odstranit portfolio z výběru?", isPresented: .constant(false)) {
            Button("Ano") {
                // remove from flagged
            }
            .foregroundColor(.red)
            
            Button("Ne") { }
        }
    }
}

#Preview {
    PortfolioDetailView(mediaWidth: 350, portfolio: .dummyPortfolio1)
}
