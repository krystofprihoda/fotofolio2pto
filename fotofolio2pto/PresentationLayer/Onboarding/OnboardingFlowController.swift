//
//  OnboardingFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import Foundation
import UIKit

public protocol OnboardingFlowControllerDelegate: AnyObject {
    func setupMain(for: String)
}

class OnboardingFlowController: BaseFlowController {
    
    weak var flowDelegate: OnboardingFlowControllerDelegate?
    
    init(
        navigationController: UINavigationController,
        flowDelegate: OnboardingFlowControllerDelegate? = nil
    ) {
        self.flowDelegate = flowDelegate
        super.init(navigationController: navigationController)
    }
    
    override func setup() -> UIViewController {
        let vm = SignInViewModel(flowController: self)
        let view = SignInView(viewModel: vm)
        let vc = BaseHostingController(rootView: view)
        return vc
    }
    
    private func finishOnboarding() {
        stopFlow()
    }
    
    public func signIn(username: String) {
        UserDefaults.standard.set(username, forKey: "signedInUser")
        finishOnboarding()
        flowDelegate?.setupMain(for: username)
    }
}
