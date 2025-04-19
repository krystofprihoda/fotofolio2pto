//
//  SelectionFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class SelectionFlowController: BaseFlowController {
    
    private let signedInUserId: String
    
    weak var tabBadgeFlowDelegate: TabBadgeFlowDelegate?
    
    init(
        navigationController: UINavigationController,
        signedInUserId: String,
        tabBadgeFlowDelegate: TabBadgeFlowDelegate? = nil
    ) {
        self.signedInUserId = signedInUserId
        self.tabBadgeFlowDelegate = tabBadgeFlowDelegate
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = SelectionViewModel(flowController: self)
        let view = SelectionView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
    
    func showProfile(user: User) {
        let fc = ProfileFlowController(
            navigationController: navigationController,
            signedInUserId: signedInUserId,
            displayedUserId: user.id,
            showDismiss: true
        )
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func sendMessage(to receiver: User) {
        let fc = MessagesFlowController(navigationController: navigationController, senderId: signedInUserId, receiverId: receiver.id)
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension SelectionFlowController: TabBadgeFlowDelegate {
    func updateCount(of tab: MainTab, to count: Int, animated: Bool) {
        tabBadgeFlowDelegate?.updateCount(of: tab, to: count, animated: animated)
    }
}
