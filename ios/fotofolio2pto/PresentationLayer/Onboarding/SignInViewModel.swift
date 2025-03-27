//
//  SignInViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 23.06.2024.
//

import Foundation
import Resolver

final class SignInViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    @LazyInjected private var loginWithCredentialsUseCase: LoginWithCredentialsUseCase
    @LazyInjected private var getUserDataUseCase: GetUserDataUseCase
    @LazyInjected private var saveSignedInUsernameUseCase: SaveSignedInUsernameUseCase

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

    struct State: Equatable {
        var email = ""
        var password = ""
        var hiddenPassword = true
        var fillUsernameAlert = false
        var fillPasswordAlert = false
        var isSigningIn = false
        var error = ""
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case signIn
        case setEmail(String)
        case setPassword(String)
        case registerUser
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .signIn: await signIn()
            case .setEmail(let email): setEmail(email)
            case .setPassword(let password): setPassword(password)
            case .registerUser: registerUser()
            }
        })
    }

    // MARK: Additional methods

    private func signIn() async {
        guard !state.email.isEmpty, !state.password.isEmpty else { return }
        
        state.isSigningIn = true
        defer { state.isSigningIn = false }
        
        do {
            let authDetails = try await loginWithCredentialsUseCase.execute(email: state.email, password: state.password)
            let user = try await getUserDataUseCase.execute(id: authDetails.uid)
            saveSignedInUsernameUseCase.execute(username: user.username)
            flowController?.signIn(uid: authDetails.uid)
        } catch {
            state.error = "Špatné přihlašovací údaje."
            state.password = ""
        }
    }
    
    private func setEmail(_ email: String) {
        state.email = email
    }
    
    private func setPassword(_ password: String) {
        state.password = password
    }
    
    private func registerUser() {
        flowController?.registerUser()
    }
}
