//
//  SelectionFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class SelectionFlowController: BaseFlowController {
    override func setup() -> UIViewController {
        let vm = SelectionViewModel(flowController: self)
        let view = SelectionView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
}
