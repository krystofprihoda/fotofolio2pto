//
//  MessagesFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class MessagesFlowController: BaseFlowController {
    override func setup() -> UIViewController {
        let vm = MessagesViewModel(flowController: self)
        let view = MessagesView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, showsNavigationBar: false)
        return vc
    }
}
