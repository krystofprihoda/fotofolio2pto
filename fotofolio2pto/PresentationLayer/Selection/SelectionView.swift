//
//  SelectionView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct SelectionView: View {
    
    @ObservedObject private var viewModel: SelectionViewModel
    
    public init(viewModel: SelectionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Selection")
    }
}

#Preview {
    SelectionView(viewModel: .init(flowController: nil))
}
