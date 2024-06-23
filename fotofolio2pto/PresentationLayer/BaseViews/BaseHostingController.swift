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

    /// Initializer to explicitly set the navigation bar visibility during presentation.
    /// - parameter rootView: The SwiftUI view
    /// - parameter showsNavigationBar: Whether the navigation bar should be shown during presentation.
    /// - note: `UIHostingController` sometimes ignores the navigation controller's property to hide navigation bar: https://stackoverflow.com/questions/63652728/swift-ui-hostingcontroller-adds-unwanted-navigation-bar
    init(
        rootView: Content,
        showsNavigationBar: Bool = true,
        navigationBarTransparent: Bool = false
    ) {
        self.showsNavigationBar = showsNavigationBar
        self.navigationBarTransparent = navigationBarTransparent
        super.init(rootView: AnyView(rootView.navigationBarHidden(!showsNavigationBar)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        navigationController?.navigationBar.setTransparency(navigationBarTransparent)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(!showsNavigationBar, animated: animated)
    }
    
    dynamic required init?(coder aDecoder: NSCoder) {
        self.showsNavigationBar = true
        self.navigationBarTransparent = true
        super.init(coder: aDecoder)
    }
    
    /// Setup custom back button arrow
    private func setupBackButton() {
        guard let nav = navigationController, nav.viewControllers.count > 1 else { return }
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            // Replace with better asset
            image: UIImage(systemName: "arrowtriangle.left"),
            style: .plain,
            target: nil,
            action: #selector(UINavigationController.popViewController(animated:))
        )
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

public extension UINavigationBar {
    func setTransparency(_ transparent: Bool) {
//        setBackgroundImage(transparent ? UIImage() : nil, for: .default)
//        shadowImage = transparent ? UIImage() : nil
        isTranslucent = transparent
    }
}
