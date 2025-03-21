//
//  BaseHostingController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI
import UIKit

class BaseHostingController<Content>: UIHostingController<AnyView>, UIGestureRecognizerDelegate where Content: View {
    
    private let showsNavigationBar: Bool
    private let navigationBarTransparent: Bool
    private let hideBackButton: Bool

    /// Initializer to explicitly set the navigation bar visibility during presentation.
    /// - parameter rootView: The SwiftUI view
    /// - parameter showsNavigationBar: Whether the navigation bar should be shown during presentation.
    /// - note: `UIHostingController` sometimes ignores the navigation controller's property to hide navigation bar: https://stackoverflow.com/questions/63652728/swift-ui-hostingcontroller-adds-unwanted-navigation-bar
    init(
        rootView: Content,
        showsNavigationBar: Bool = true,
        navigationBarTransparent: Bool = false,
        hideBackButton: Bool = false
    ) {
        self.showsNavigationBar = showsNavigationBar
        self.navigationBarTransparent = navigationBarTransparent
        self.hideBackButton = hideBackButton
        super.init(rootView: AnyView(rootView.navigationBarHidden(!showsNavigationBar)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeBackGesture()
        // navigationController?.navigationBar.setTransparency(navigationBarTransparent)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = hideBackButton
        navigationController?.setNavigationBarHidden(!showsNavigationBar, animated: animated)
        
        if navigationBarTransparent { makeNavigationBarFullyTransparent() }
    }
    
    dynamic required init?(coder aDecoder: NSCoder) {
        self.showsNavigationBar = true
        self.navigationBarTransparent = true
        self.hideBackButton = false
        super.init(coder: aDecoder)
    }
    
    private func setupSwipeBackGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
    
    private func makeNavigationBarFullyTransparent() {
        guard let navBar = navigationController?.navigationBar else { return }

        let transparentAppearance = UINavigationBarAppearance()
        transparentAppearance.configureWithTransparentBackground() // True transparency
        transparentAppearance.backgroundColor = .clear
        transparentAppearance.shadowColor = .clear
        transparentAppearance.shadowImage = UIImage()
        
        navBar.standardAppearance = transparentAppearance
        navBar.scrollEdgeAppearance = transparentAppearance
        navBar.compactAppearance = transparentAppearance

        navBar.isTranslucent = true
        navBar.setBackgroundImage(UIImage(), for: .default) // Removes any solid background
        navBar.shadowImage = UIImage() // Removes the bottom shadow
    }
}

public extension UINavigationBar {
    func setTransparency(_ transparent: Bool) {
        isTranslucent = transparent
    }
}
