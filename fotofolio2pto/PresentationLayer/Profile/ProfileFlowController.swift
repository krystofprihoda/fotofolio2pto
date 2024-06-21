//
//  ProfileFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class ProfileFlowController: BaseFlowController {
    override func setup() -> UIViewController {
        let vm = ProfileViewModel(flowController: self)
        let view = ProfileView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, showsNavigationBar: false)
        return vc
    }
}
