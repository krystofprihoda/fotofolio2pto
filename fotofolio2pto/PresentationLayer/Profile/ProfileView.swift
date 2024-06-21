//
//  ProfileView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Profile")
    }
}

#Preview {
    ProfileView(viewModel: .init(flowController: nil))
}
