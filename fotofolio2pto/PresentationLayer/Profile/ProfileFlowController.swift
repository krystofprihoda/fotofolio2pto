//
//  ProfileFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit
import SwiftUI

public protocol ProfileFlowControllerDelegate: AnyObject {
    func signOut()
}

class ProfileFlowController: BaseFlowController {
    
    private let signedInUser: String
    private let displayedUser: String
    
    weak var flowDelegate: ProfileFlowControllerDelegate?

    init(
        navigationController: UINavigationController,
        flowDelegate: ProfileFlowControllerDelegate? = nil,
        signedInUser: String,
        displayedUser: String
    ) {
        self.flowDelegate = flowDelegate
        self.signedInUser = signedInUser
        self.displayedUser = displayedUser
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = ProfileViewModel(flowController: self, signedInUser: signedInUser, displayedUser: displayedUser)
        let view = ProfileView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
    
    public func sendMessage(from sender: String, to receiver: String) {
        let fc = MessagesFlowController(navigationController: navigationController, sender: sender, receiver: receiver)
        let vc = startChildFlow(fc)
        navigationController.navigationBar.tintColor = .gray
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showProfileEdit(userData: User, portfolios: [Portfolio]) {
        let vm = EditProfileViewModel(flowController: self, userData: userData, portfolios: portfolios)
        let view = EditProfileView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.navigationBar.tintColor = .gray
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showCreateNewPortfolio(user: User) {
        let vm = NewPortfolioViewModel(flowController: self, userData: user)
        let view = NewPortfolioView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        navigationController.navigationBar.tintColor = .gray
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func presentPickerModal(source: MediaPickerSource) {
        let vc = BaseHostingController(
            rootView: MediaPickerView(
                media: source.media,
                selectionLimit: 5
            )
        )
        navigationController.present(vc, animated: true)
    }
}
