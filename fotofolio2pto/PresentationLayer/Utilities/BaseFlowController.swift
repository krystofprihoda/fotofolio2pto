//
//  BaseFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import UIKit
import OSLog

protocol Flow {}

@MainActor
public class BaseFlowController: NSObject {
    
    let navigationController: UINavigationController
    
    private weak var parentController: BaseFlowController?
    private(set) var childControllers: [BaseFlowController] = []
    
    private(set) var rootViewController: UIViewController?
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        Logger.lifecycle.info("👶 | \(type(of: self)) initialized 🌊")
    }
    
    deinit {
        Logger.lifecycle.info("💀 | \(type(of: self)) deinitialized 🌊")
    }
    
    /// Override this method in a subclass and return initial ViewController of the flow.
    func setup() -> UIViewController {
        UIViewController()
    }
    
    /// Override this method in a subclass and setup handlings for all required flows.
    func handleFlow(_ flow: Flow) {}
    
    /// Default implementation for dismissing a modal flow. Override in a subclass if you want a custom behavior.
    func dismiss() {
        navigationController.dismiss(animated: true, completion: { [weak self] in
            self?.stopFlow()
        })
    }
    
    /// Starts child flow controller and returns initial ViewController.
    func startChildFlow(_ flowController: BaseFlowController) -> UIViewController {
        childControllers.append(flowController)
        flowController.parentController = self
        flowController.navigationController.delegate = flowController
        flowController.rootViewController = flowController.setup()
        return flowController.rootViewController ?? UIViewController()
    }
    
    /// Stops flow controller. Must be called when returning to a parent flow controller.
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
        // Stop a child flow controller when returning to a parent flow controller via back button
        // Idea taken from [Back Buttons and Coordinators](http://khanlou.com/2017/05/back-buttons-and-coordinators/)
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
