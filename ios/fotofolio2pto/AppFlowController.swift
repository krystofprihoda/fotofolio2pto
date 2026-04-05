//
//  AppFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit
import Resolver
import SwiftUI

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
        let backgroundImageView = UIImageView(image: Asset.sgrain.image)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.5
        blurView.translatesAutoresizingMaskIntoConstraints = false

        navigationController.view.insertSubview(backgroundImageView, at: 0)
        navigationController.view.insertSubview(blurView, at: 1)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: navigationController.view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: navigationController.view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor)
        ])

        navigationController.view.backgroundColor = .clear
    }
    
    private func setupAppearance() {
        // Navigation bar - transparent
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().isTranslucent = true

        // Force dark liquid glass tint on iOS 26
        UINavigationBar.appearance().overrideUserInterfaceStyle = .dark
        UITabBar.appearance().overrideUserInterfaceStyle = .dark

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
