//
//  OnboardingFlowController.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import Foundation
import UIKit

public protocol OnboardingMainFlowDelegate: AnyObject {
    func setupMain(for: String)
}

class OnboardingFlowController: BaseFlowController {
    
    weak var onboardingMainflowDelegate: OnboardingMainFlowDelegate?
    
    init(
        navigationController: UINavigationController,
        onboardingMainflowDelegate: OnboardingMainFlowDelegate? = nil
    ) {
        self.onboardingMainflowDelegate = onboardingMainflowDelegate
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
        onboardingMainflowDelegate?.setupMain(for: uid)
    }
    
    public func registerUser() {
        let fc = RegisterFlowController(navigationController: navigationController)
        let vc = startChildFlow(fc)
        navigationController.pushViewController(vc, animated: true)
    }
}
