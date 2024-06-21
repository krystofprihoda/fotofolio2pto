//
//  AppFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit

public class AppFlowController: BaseFlowController {
    public func start() {
        setupAppearance()
        
        if true {
            setupMain()
        } else {
            presentOnboarding()
        }
    }
    
    private func setupMain() {
        let flowController = MainFlowController(
            navigationController: navigationController
        )
        let rootVc = startChildFlow(flowController)
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [rootVc]
    }
    
    private func presentOnboarding() {
        
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
