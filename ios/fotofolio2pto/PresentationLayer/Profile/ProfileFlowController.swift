//
//  ProfileFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit
import SwiftUI

public protocol ProfileSignOutDelegate: AnyObject {
    func signOut()
}

class ProfileFlowController: BaseFlowController {
    
    private let signedInUserId: String
    private let displayedUserId: String
    private let showDismiss: Bool
    
    weak var profileSignOutDelegate: ProfileSignOutDelegate?

    init(
        navigationController: UINavigationController,
        profileSignOutDelegate: ProfileSignOutDelegate? = nil,
        signedInUserId: String,
        displayedUserId: String,
        showDismiss: Bool = false
    ) {
        self.profileSignOutDelegate = profileSignOutDelegate
        self.signedInUserId = signedInUserId
        self.displayedUserId = displayedUserId
        self.showDismiss = showDismiss
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = ProfileViewModel(
            flowController: self,
            signedInUserId: signedInUserId,
            displayedUserId: displayedUserId,
            showDismiss: showDismiss
        )
        let view = ProfileView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        return vc
    }
    
    public func sendMessage(from senderId: String, to receiverId: String) {
        let fc = MessagesFlowController(navigationController: navigationController, senderId: senderId, receiverId: receiverId)
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showProfileSettings(userData: User, portfolios: [Portfolio]) {
        let vm = SettingsViewModel(flowController: self, userData: userData, portfolios: portfolios)
        let view = SettingsView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showProfileEdit(userData: User, portfolios: [Portfolio]) {
        let vm = EditProfileViewModel(flowController: self, userData: userData, portfolios: portfolios)
        let view = EditProfileView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showCreateNewPortfolio(authorUsername: String) {
        let vm = EditPortfolioViewModel(flowController: self, portfolioAuthorUsername: authorUsername)
        let view = EditPortfolioView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
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
    
    public func showEditPortfolio(_ portfolio: Portfolio, author: String) {
        let vm = EditPortfolioViewModel(flowController: self, portfolioAuthorUsername: author, intent: .updateExisting(portfolio))
        let view = EditPortfolioView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
}
