//
//  EditProfileView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct EditProfileView: View {
    
    @ObservedObject var viewModel: EditProfileViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                //Profile info
                EditPersonalDetailsView(viewModel: viewModel)
                
                if viewModel.state.userData?.creator != nil {
                    EditProfileDetailsView(viewModel: viewModel)
                    EditPortfolioView(viewModel: viewModel)
                }
            }
        }
        .setupNavBarAndTitle(L.Profile.editTitle)
//        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    // onIntent(.save)
                }) {
                    Text(L.Profile.save)
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 5)
            }
            
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    // Cancel
                }) {
                    Text(L.Profile.cancel)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 5)
            }
        }
    }
}

#Preview {
    EditProfileView(viewModel: .init(flowController: nil, userData: .dummy1, portfolios: [.dummyPortfolio1]))
}
