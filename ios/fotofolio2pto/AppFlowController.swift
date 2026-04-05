//
//  AppFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit
import Resolver
import SwiftUI // ADDED: Required for UIHostingController

public class AppFlowController: BaseFlowController, OnboardingMainFlowDelegate {
    
    public func start() {
        setupAppearance()
        setupGlobalBackground() // ADDED: Initialize the mesh background
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
    
    // MARK: - Global Background Setup
    private func setupGlobalBackground() {
        let meshView = AnimatedMeshPlaceholder(style: .darkCenter, isAnimating: false)
            .ignoresSafeArea()
        
        // 2. Wrap it in a UIHostingController
        let hostingController = UIHostingController(rootView: meshView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        // 3. Insert it at the very bottom of the navigation controller's view stack
        navigationController.view.insertSubview(hostingController.view, at: 0)
        
        // 4. Pin it to the edges of the navigation controller
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: navigationController.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor)
        ])
        
        // Ensure the navigation controller itself is transparent
        navigationController.view.backgroundColor = .clear
    }
    
    private func setupAppearance() {
        // Navigation bar
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        // Tab bar
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
}

extension AppFlowController: MainAppFlowDelegate {
    public func signOut() {
        presentOnboarding()
    }
}
