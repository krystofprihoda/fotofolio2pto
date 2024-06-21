//
//  FeedFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class FeedFlowController: BaseFlowController {
    override func setup() -> UIViewController {
        let vm = FeedViewModel(flowController: self)
        let view = FeedView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
}
