//
//  ProfileFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

public protocol ProfileFlowControllerDelegate: AnyObject {
    func signOut()
}

class ProfileFlowController: BaseFlowController {
    
    private let user: String
    weak var flowDelegate: ProfileFlowControllerDelegate?
    
    init(
        navigationController: UINavigationController,
        flowDelegate: ProfileFlowControllerDelegate? = nil,
        user: String
    ) {
        self.user = user
        self.flowDelegate = flowDelegate
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = ProfileViewModel(flowController: self, user: user)
        let view = ProfileView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
}
