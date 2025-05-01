//
//  BaseFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//  Reused from https://github.com/MateeDevs/devstack-native-app/tree/develop
//

import Foundation
import UIKit
import OSLog

@MainActor
public class BaseFlowController: NSObject {
    
    let navigationController: UINavigationController
    
    private weak var parentController: BaseFlowController?
    private(set) var childControllers: [BaseFlowController] = []
    
    private(set) var rootViewController: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        Logger.lifecycle.info("👶 | \(type(of: self)) initialized 🌊")
    }
    
    deinit {
        Logger.lifecycle.info("💀 | \(type(of: self)) deinitialized 🌊")
    }
    
    /// Override in a subclass to return the initial ViewController
    func setup() -> UIViewController {
        UIViewController()
    }
    
    /// Default implementation for a dismiss, can be overriden
    func dismiss() {
        navigationController.dismiss(animated: true, completion: { [weak self] in
            self?.stopFlow()
        })
    }
    
    /// Starts a child flow and returns the initial VC
    func startChildFlow(_ flowController: BaseFlowController) -> UIViewController {
        childControllers.append(flowController)
        flowController.parentController = self
        flowController.navigationController.delegate = flowController
        flowController.rootViewController = flowController.setup()
        return flowController.rootViewController ?? UIViewController()
    }
    
    /// Removes the flow controller. Must be called when returning to a parent flow controller.
    func stopFlow() {
        parentController?.removeChild(self)
    }
    
    private func removeChild(_ flowController: BaseFlowController) {
        if let index = childControllers.firstIndex(where: { $0 === flowController }) {
            childControllers.remove(at: index)
        }
    }
}

extension BaseFlowController: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        /// Back button solution for stopping a child flow when returning to the parent flow
        /// Original idea(http://khanlou.com/2017/05/back-buttons-and-coordinators/)
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromViewController),
            fromViewController == rootViewController else { return }
        stopFlow()
    }
}

public extension Logger {
    static let app = Logger(subsystem: Bundle.main.bundleIdentifier ?? "-", category: "App")
    static let networking = Logger(subsystem: Bundle.main.bundleIdentifier ?? "-", category: "Networking")
    static let lifecycle = Logger(subsystem: Bundle.main.bundleIdentifier ?? "-", category: "Lifecycle")
}
