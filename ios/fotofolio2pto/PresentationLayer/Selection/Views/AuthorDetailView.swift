//
//  AuthorDetailView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct AuthorDetailView: View {
    
    private let author: User
    private let creator: Creator
    private let unflagPortfolio: () -> Void
    private let showProfile: () -> Void
    private let sendMessage: () -> Void
    
    init(
        author: User,
        creator: Creator,
        unflagPortfolio: @escaping () -> Void,
        showProfile: @escaping () -> Void,
        sendMessage: @escaping () -> Void
    ) {
        self.author = author
        self.creator = creator
        self.unflagPortfolio = unflagPortfolio
        self.showProfile = showProfile
        self.sendMessage = sendMessage
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: showProfile) {
                    Text("@\(author.username)")
                        .font(.title3)
                        .padding(.leading, 20)
                        .foregroundColor(.mainAccent)
                }
                
                Spacer()
                
                Button(action: sendMessage) {
                    Text(L.Selection.typeMessage)
                        .foregroundColor(.gray)
                }
                
                Button(action: unflagPortfolio) {
                    Image(systemName: "bookmark.slash")
                        .foregroundColor(.black)
                }
                .padding(.trailing, 20)
            }
            .padding(.bottom, 1)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(author.fullName)")
                        .foregroundColor(.black).brightness(0.3)
                        .font(.system(size: 16))
                    
                    if !author.rating.isEmpty {
                        HStack {
                            Text("\(author.location), " + String(format: "%.1f", author.averageRating) + L.Selection.outOf5)
                                .font(.system(size: 12))
                                .foregroundColor(.black).brightness(0.3)
                            
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.black).brightness(0.3)
                                .offset(x: -5)
                        }
                    } else {
                        Text("\(author.location), \(L.Selection.noRating)")
                            .font(.system(size: 12))
                            .foregroundColor(.black).brightness(0.3)
                    }
                }
                .padding(.leading, 25)
                
                Spacer()
            }
            
            HStack {
                Text(creator.profileText)
                    .font(.system(size: 16))
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
                Spacer()
            }
            .padding(.top, 5)
            .padding(.leading, 21)
            .padding(.trailing, 21)
        }
    }
}

#Preview {
    AuthorDetailView(author: .dummy1, creator: .dummy1, unflagPortfolio: {}, showProfile: {}, sendMessage: {})
}
