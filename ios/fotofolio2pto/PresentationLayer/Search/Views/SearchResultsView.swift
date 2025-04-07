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
                        ProfilePictureView(profilePicture: user.profilePicture, width: Constants.Dimens.frameSizeSmallMedium)
                        
                        VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
                            Text(user.username)
                                .font(.body)
                                .foregroundColor(.black)
                                .brightness(Constants.Dimens.opacityLow)
                                .padding(.bottom, Constants.Dimens.spaceXSmall)
                            
                            Text(user.location)
                                .font(.callout)
                                .foregroundColor(.black).brightness(Constants.Dimens.opacityLow)
                                .padding(.bottom, Constants.Dimens.spaceXXSmall)
                        }
                        .padding(.leading, Constants.Dimens.spaceSmall)
                        
                        Spacer()
                    }
                    .padding(.top, Constants.Dimens.spaceMedium)
                    .transition(.move(edge: .trailing))
                })
            }
        }
    }
}

#Preview {
    SearchResultsView(results: [.dummy1], onResultTap: { _ in })
}
