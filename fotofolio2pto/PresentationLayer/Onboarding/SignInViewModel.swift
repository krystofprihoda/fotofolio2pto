//
//  SignInViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import Foundation

final class SignInViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    // UCs

    private weak var flowController: OnboardingFlowController?

    // MARK: Init

    init(
        flowController: OnboardingFlowController?
    ) {
        self.flowController = flowController
        super.init()
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State {
        var username = ""
        var password = ""
        var hiddenPassword = true
        var fillUsernameAlert = false
        var fillPasswordAlert = false
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case signIn
        case setUsername(String)
        case setPassword(String)
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .signIn: signIn()
            case .setUsername(let username): setUsername(username)
            case .setPassword(let password): setPassword(password)
            }
        })
    }

    // MARK: Additional methods

    private func signIn() {
        // checks
        flowController?.signIn(username: state.username)
    }
    
    private func setUsername(_ username: String) {
        state.username = username
    }
    
    private func setPassword(_ password: String) {
        state.password = password
    }
}
