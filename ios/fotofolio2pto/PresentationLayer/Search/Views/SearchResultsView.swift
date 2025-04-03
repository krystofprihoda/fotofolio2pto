//
//  SearchResultsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import SwiftUI

struct SearchResultsView: View {
    
    private let results: [User]
    private let onResultTap: (User) -> Void
    
    init(
        results: [User],
        onResultTap: @escaping (User) -> Void
    ) {
        self.results = results
        self.onResultTap = onResultTap
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(results, id: \.id) { user in
                Button(action: { onResultTap(user) }, label: {
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
                })
            }
        }
    }
}

#Preview {
    SearchResultsView(results: [.dummy1], onResultTap: { _ in })
}
