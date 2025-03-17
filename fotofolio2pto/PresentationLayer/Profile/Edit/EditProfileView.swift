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
                    EditCreatorDetailsView(viewModel: viewModel)
                    EditPortfoliosView(viewModel: viewModel)
                }
            }
        }
        .alert(item: Binding<AlertData?>(
            get: { viewModel.state.alertData },
            set: { alertData in
                viewModel.onIntent(.onAlertDataChanged(alertData))
            }
        )) { alert in .init(alert) }
        .navigationBarItems(leading: cancelButton, trailing: saveButton)
        .setupNavBarAndTitle(L.Profile.editTitle, hideBack: true)
    }
    
    private var saveButton: some View {
        Button(action: { viewModel.onIntent(.saveChanges) }) {
            Text(L.Profile.save)
        }
        .foregroundColor(viewModel.state.isSaveButtonDisabled ? .gray : .black)
        .disabled(viewModel.state.isSaveButtonDisabled)
    }

   private var cancelButton: some View {
       Button(action: { viewModel.onIntent(.cancel) }) {
           Text(L.Profile.back)
               .foregroundColor(.black)
       }
   }
}

#Preview {
    EditProfileView(viewModel: .init(flowController: nil, userData: .dummy1, portfolios: [.dummyPortfolio1]))
}
