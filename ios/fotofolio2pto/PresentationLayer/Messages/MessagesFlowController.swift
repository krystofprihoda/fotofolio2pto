//
//  MessagesFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

class MessagesFlowController: BaseFlowController {
    
    private let senderId: String
    private let receiverId: String?
    
    init(
        navigationController: UINavigationController,
        senderId: String,
        receiverId: String? = nil
    ) {
        self.senderId = senderId
        self.receiverId = receiverId
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        if let receiverId {
            let vm = ChatViewModel(flowController: self, senderId: senderId, receiverId: receiverId)
            let view = ChatView(viewModel: vm)
            let vc = BaseHostingController(rootView: view)
            return vc
        } else {
            let vm = AllChatsViewViewModel(flowController: self, senderId: senderId)
            let view = AllChatsView(viewModel: vm)
            let vc = BaseHostingController(rootView: view)
            return vc
        }
    }
    
    public func showChat(senderId: String, receiverId: String) {
        let vm = ChatViewModel(flowController: self, senderId: senderId, receiverId: receiverId)
        let view = ChatView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showNewChat() {
        let vm = SearchViewModel(messagesFlowController: self, signedInUserId: senderId, searchIntent: .chat)
        let view = SearchView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
}
