//
//  RegisterFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 04.03.2025.
//

import UIKit

class RegisterFlowController: BaseFlowController {
    override func setup() -> UIViewController {
        let vm = RegisterViewModel(flowController: self)
        let view = RegisterView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, showsNavigationBar: false)
        return vc
    }
}
