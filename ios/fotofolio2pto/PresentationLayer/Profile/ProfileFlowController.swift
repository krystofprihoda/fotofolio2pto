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
    
    public func showProfileEdit(userData: User) {
        let vm = EditProfileViewModel(flowController: self, userData: userData)
        let view = EditProfileView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showPortfoliosEdit(creatorId: String, portfolios: [Portfolio]) {
        let vm = EditPortfoliosViewModel(flowController: self, creatorId: creatorId, portfolios: portfolios)
        let view = EditPortfoliosView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showCreateNewPortfolio(creatorId: String) {
        let vm = EditPortfolioViewModel(flowController: self, creatorId: creatorId)
        let view = EditPortfolioView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func showGiveRating(receiverId: String) {
        let vm = GiveRatingViewModel(flowController: self, receiverId: receiverId)
        let view = GiveRatingView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func presentPickerModal(source: MediaPickerSource, limit: Int) {
        let vc = BaseHostingController(
            rootView: MediaPickerView(
                media: source.media,
                selectionLimit: limit
            )
        )
        navigationController.present(vc, animated: true)
    }
    
    public func showEditPortfolio(_ portfolio: Portfolio, creatorId: String, updatePortfolioProfileFlowDelegate: UpdatePortfolioProfileFlowDelegate?) {
        let vm = EditPortfolioViewModel(
            flowController: self,
            updatePortfolioProfileFlowDelegate: updatePortfolioProfileFlowDelegate,
            creatorId: creatorId,
            intent: .updateExisting(portfolio)
        )
        let view = EditPortfolioView(viewModel: vm)
        let vc = BaseHostingController(rootView: view, hideBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
}
