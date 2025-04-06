//
//  SettingsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 17.03.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject private var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section(header: Text(L.Profile.title)) {
                Button(action: { viewModel.onIntent(.editProfile) }, label: {
                    Label(L.Profile.editProfile, systemImage: "person.circle")
                        .foregroundStyle(.black)
                })
            }
            
            Section(header: Text(L.Profile.portfolios)) {
                Button(action: { viewModel.onIntent(.editPortfolios) }, label: {
                    Label(L.Profile.editPortfolios, systemImage: "text.below.photo")
                        .foregroundStyle(.black)
                })
            }
            
            Section {
                Button(action: { viewModel.onIntent(.signOut) }, label: {
                    Label(L.Profile.signOut, systemImage: "arrow.backward.circle")
                        .foregroundStyle(.red)
                })
            }
        }
        .navigationBarItems(leading: backButton)
        .setupNavBarAndTitle(L.Profile.settings, hideBack: true)
    }
    
    var backButton: some View {
        Button(L.Profile.back) {
            viewModel.onIntent(.goBack)
        }
        .foregroundStyle(.black)
    }
}
