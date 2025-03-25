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
    
    weak var feedTabBadgeFlowDelegate: FeedTabBadgeDelegate?
    
    init(
        navigationController: UINavigationController,
        signedInUserId: String,
        feedTabBadgeFlowDelegate: FeedTabBadgeDelegate? = nil
    ) {
        self.signedInUserId = signedInUserId
        self.feedTabBadgeFlowDelegate = feedTabBadgeFlowDelegate
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
            displayedUser: user.username,
            showDismiss: true
        )
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func sendMessage(to receiver: User) {
        let fc = MessagesFlowController(navigationController: navigationController, sender: signedInUserId, receiver: receiver.username)
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension SelectionFlowController: FeedTabBadgeDelegate {
    func updateCount(to count: Int, animated: Bool) {
        feedTabBadgeFlowDelegate?.updateCount(to: count, animated: animated)
    }
}
