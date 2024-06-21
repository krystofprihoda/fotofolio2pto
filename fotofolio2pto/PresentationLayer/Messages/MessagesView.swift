//
//  MessagesView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct MessagesView: View {
    
    @ObservedObject private var viewModel: MessagesViewModel
    
    init(viewModel: MessagesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Messages")
    }
}

#Preview {
    MessagesView(viewModel: .init(flowController: nil))
}
