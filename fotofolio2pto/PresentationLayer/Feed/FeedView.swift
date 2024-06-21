//
//  FeedView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject private var viewModel: FeedViewModel
    
    public init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Feed")
    }
}

#Preview {
    FeedView(viewModel: .init(flowController: nil))
}
