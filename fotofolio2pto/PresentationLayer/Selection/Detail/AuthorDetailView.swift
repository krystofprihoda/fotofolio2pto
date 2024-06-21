//
//  AuthorDetailView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct AuthorDetailView: View {
    
    private let author: User
    
    init(author: User) {
        self.author = author
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // profile view
                }, label: {
                    Text("@\(author.username)")
                        .font(.title3)
                        .padding(.leading, 20)
                        .foregroundColor(.pink)
                })
                
                Spacer()
                
                Button(action: {
                    // chat view
                }) {
                    Text("Napsat zprávu")
                        .foregroundColor(.cyan)
                }
                
                Button(action: {
                    // remove folio
                }) {
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
                    
                    if !author.ratings.isEmpty {
                        HStack {
                            Text("\(author.location), " + String(format: "%.1f", author.calculateRating()) + " z 5")
                                .font(.system(size: 12))
                                .foregroundColor(.black).brightness(0.3)
                            
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.black).brightness(0.3)
                                .offset(x: -5)
                        }
                    } else {
                        Text("\(author.location), " + "Bez hodnocení")
                            .font(.system(size: 12))
                            .foregroundColor(.black).brightness(0.3)
                    }
                }
                .padding(.leading, 25)
                
                Spacer()
            }
            
            HStack {
                Text(author.creator?.profileText ?? "Profilový popis se nepodařilo nahrát, zkuste to znovu.")
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
    AuthorDetailView(author: .dummy1)
}
