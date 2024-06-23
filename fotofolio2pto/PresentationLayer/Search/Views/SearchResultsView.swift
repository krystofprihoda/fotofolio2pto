//
//  SearchResultsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import SwiftUI

struct SearchResultsView: View {
    
    private let results: [User]
    
    init(results: [User]) {
        self.results = results
    }
    
    var body: some View {
        ForEach(results, id: \.id) { user in
//            NavigationLink(destination: ProfileView(profileViewModel: .init(), user: user.username, signOutClear: .constant(false))) {
                HStack {
                    ProfilePictureView(profilePicture: user.profilePicture, width: 60.0)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(user.username)
                            .font(.system(size: 16))
                            .foregroundColor(.black).brightness(0.2)
                            .padding(.bottom, 4)
                        
                        Text(user.location)
                            .font(.system(size: 13))
                            .foregroundColor(.black).brightness(0.3)
                            .padding(.bottom, 2)
                    }
                    .padding(.leading, 7)
                    
                    Spacer()
                }
                .padding(.top, 12)
                .transition(.move(edge: .trailing))
//            }
        }
    }
}

#Preview {
    SearchResultsView(results: [.dummy1])
}
