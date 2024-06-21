//
//  SearchFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class SearchFlowController: BaseFlowController {
    override func setup() -> UIViewController {
        let vm = SearchViewModel(flowController: self)
        let view = SearchView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, showsNavigationBar: false)
        return vc
    }
}
