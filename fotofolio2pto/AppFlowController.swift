//
//  AppFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit
import Resolver

public class AppFlowController: BaseFlowController, OnboardingFlowControllerDelegate {
    
    @LazyInjected private var getLoggedInUserUseCase: GetLoggedInUserUseCase
    
    public func start() {
        setupAppearance()
        
        let user = getLoggedInUserUseCase.execute()
        
        if let user {
            setupMain(for: user)
        } else {
            presentOnboarding()
        }
    }
    
    public func setupMain(for user: String) {
        let flowController = MainFlowController(
            navigationController: navigationController,
            flowDelegate: self,
            user: user
        )
        let rootVc = startChildFlow(flowController)
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [rootVc]
        navigationController.overrideUserInterfaceStyle = .light
    }
    
    private func presentOnboarding() {
        let flowController = OnboardingFlowController(
            navigationController: navigationController,
            flowDelegate: self
        )
        let rootVc = startChildFlow(flowController)
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [rootVc]
        navigationController.overrideUserInterfaceStyle = .light
    }
    
    private func setupAppearance() {
        // Replace with AppTheme
        
        // Navigation bar
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        // Tab bar
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .white
    }
}

extension AppFlowController: MainFlowControllerDelegate {
    public func signOut() {
        presentOnboarding()
    }
}
