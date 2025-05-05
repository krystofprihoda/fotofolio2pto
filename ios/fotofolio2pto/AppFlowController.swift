//
//  AppFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit
import Resolver

public class AppFlowController: BaseFlowController, OnboardingMainFlowDelegate {
    
    @LazyInjected private var getLoggedInUserUseCase: ReadLoggedInUserUseCase
    
    public func start() {
        setupAppearance()
        presentOnboarding()
    }
    
    public func setupMain(for userId: String) {
        let flowController = MainFlowController(
            navigationController: navigationController,
            mainAppFlowDelegate: self,
            userId: userId
        )
        let rootVc = startChildFlow(flowController)
        navigationController.viewControllers = [rootVc]
        navigationController.navigationBar.isHidden = true
        navigationController.overrideUserInterfaceStyle = .light
    }
    
    private func presentOnboarding() {
        let flowController = OnboardingFlowController(
            navigationController: navigationController,
            onboardingMainflowDelegate: self
        )
        let rootVc = startChildFlow(flowController)
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [rootVc]
        navigationController.overrideUserInterfaceStyle = .light
    }
    
    private func setupAppearance() {
        if #available(iOS 13.0, *) {
            if UIApplication.shared.keyWindow!.overrideUserInterfaceStyle == .dark {
                UIApplication.shared.keyWindow!.overrideUserInterfaceStyle = .light
            } else {
                UIApplication.shared.keyWindow!.overrideUserInterfaceStyle = .light
            }
        }
        
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

extension AppFlowController: MainAppFlowDelegate {
    public func signOut() {
        presentOnboarding()
    }
}
