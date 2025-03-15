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
                
                if viewModel.state.isCreator {
                    EditProfileDetailsView(viewModel: viewModel)
                    EditPortfolioView(viewModel: viewModel)
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
        .navigationBarItems(leading: cancelButton, trailing: saveButton)
        .setupNavBarAndTitle(L.Profile.editTitle)
    }
    
    private var saveButton: some View {
        Button(action: {}) {
               Text(L.Profile.save)
                   .foregroundColor(.gray)
           }
       }

   private var cancelButton: some View {
       Button(action: {}) {
           Text(L.Profile.cancel)
               .foregroundColor(.gray)
       }
   }
}

#Preview {
    EditProfileView(viewModel: .init(flowController: nil, userData: .dummy1, portfolios: [.dummyPortfolio1]))
}
