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
                }
            }
        }
        .toast(toastData: Binding(get: { viewModel.state.toastData }, set: { viewModel.onIntent(.setToastData($0)) }))
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
            if viewModel.state.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Text(L.Profile.save)
            }
        }
        .foregroundColor(viewModel.state.isSaveButtonDisabled ? .gray : .black)
        .disabled(viewModel.state.isSaveButtonDisabled)
    }

   private var cancelButton: some View {
       Button(action: { viewModel.onIntent(.cancel) }) {
           Text(L.General.back)
               .foregroundColor(.black)
       }
   }
}

#Preview {
    EditProfileView(viewModel: .init(flowController: nil, userData: .dummy1))
}
