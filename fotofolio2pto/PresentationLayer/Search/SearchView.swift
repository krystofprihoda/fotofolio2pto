//
//  SearchView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Search")
    }
}

#Preview {
    SearchView(viewModel: .init(flowController: nil))
}
