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
        let vc = BaseHostingController(rootView: view, showsNavigationBar: false)
        return vc
    }
    
    private func finishOnboarding() {
        stopFlow()
    }
    
    public func signIn(uid: String) {
        finishOnboarding()
        flowDelegate?.setupMain(for: uid)
    }
    
    public func registerUser() {
        let fc = RegisterFlowController(navigationController: navigationController)
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
}
