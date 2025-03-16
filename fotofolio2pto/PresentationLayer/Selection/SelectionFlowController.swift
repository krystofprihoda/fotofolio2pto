//
//  SelectionFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class SelectionFlowController: BaseFlowController {
    
    private let signedInUser: String
    
    init(
        navigationController: UINavigationController,
        signedInUser: String
    ) {
        self.signedInUser = signedInUser
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = SelectionViewModel(flowController: self)
        let view = SelectionView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
    
    func showProfile(user: User) {
        let fc = ProfileFlowController(navigationController: navigationController, signedInUser: signedInUser, displayedUser: user.username)
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func sendMessage(to receiver: User) {
        let fc = MessagesFlowController(navigationController: navigationController, sender: signedInUser, receiver: receiver.username)
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
}
