//
//  MessagesFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class MessagesFlowController: BaseFlowController {
    
    private let sender: String
    private let receiver: String?
    
    init(
        navigationController: UINavigationController,
        sender: String,
        receiver: String? = nil
    ) {
        self.sender = sender
        self.receiver = receiver
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        if let receiver {
            let vm = ChatViewModel(flowController: self, sender: sender, receiver: receiver)
            let view = ChatView(viewModel: vm)
            let vc = BaseHostingController(rootView: view)
            return vc
        } else {
            let vm = MessagesViewModel(flowController: self, signedInUser: sender)
            let view = MessagesView(viewModel: vm)
            let vc = BaseHostingController(rootView: view)
            return vc
        }
    }
    
    public func showChat(sender: String, receiver: String) {
        let vm = ChatViewModel(flowController: self, sender: sender, receiver: receiver)
        let view = ChatView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        navigationController.navigationBar.tintColor = .gray
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showNewChat() {
        let vm = NewChatSearchViewModel(flowController: self, sender: sender)
        let view = NewChatSearchView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        navigationController.navigationBar.tintColor = .gray
        navigationController.pushViewController(vc, animated: true)
    }
}
