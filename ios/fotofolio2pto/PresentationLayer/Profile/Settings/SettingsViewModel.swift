//
//  SettingsViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 17.03.2025.
//

import Resolver
import SwiftUI

final class SettingsViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    @LazyInjected private var signOutUseCase: SignOutUseCase
    
    private weak var flowController: ProfileFlowController?
    
    // MARK: Init
    
    init(
        flowController: ProfileFlowController?,
        userData: User,
        portfolios: [Portfolio]
    ) {
        self.flowController = flowController
        super.init()
        state.userData = userData
        state.portfolios = portfolios
    }
    
    // MARK: State
    
    struct State {
        var userData: User! = nil
        var portfolios: [Portfolio] = []
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case editProfile
        case editPortfolios
        case signOut
        case goBack
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .editProfile: editProfile()
            case .editPortfolios: editPortfolios()
            case .signOut: signOut()
            case .goBack: dismissView()
            }
        })
    }
    
    // MARK: Additional methods
    
    private func editProfile() {
        guard let userData = state.userData else { return }
        flowController?.showProfileEdit(userData: userData)
    }
    
    private func editPortfolios() {
        guard let creatorId = state.userData?.creatorId else { return }
        flowController?.showPortfoliosEdit(creatorId: creatorId, portfolios: state.portfolios)
    }
    
    private func signOut() {
        do {
            try signOutUseCase.execute()
            flowController?.profileSignOutDelegate?.signOut()
        } catch {}
    }
    
    private func dismissView() {
        flowController?.navigationController.popViewController(animated: true)
    }
}
