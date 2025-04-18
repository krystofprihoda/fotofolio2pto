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
    
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    // MARK: Dependencies

    @LazyInjected private var loginWithCredentialsUseCase: LoginWithCredentialsUseCase
    @LazyInjected private var readUserByIdUseCase: ReadUserByIdUseCase
    @LazyInjected private var readLastSignedInEmailUseCase: ReadLastSignedInEmailUseCase

    private weak var flowController: OnboardingFlowController?

    // MARK: Init

    init(
        flowController: OnboardingFlowController?
    ) {
        self.flowController = flowController
        super.init()
        state.email = readLastSignedInEmailUseCase.execute()
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State: Equatable {
        var email = ""
        var isValidEmail = false
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
            flowController?.signIn(uid: authDetails.uid)
        } catch AuthError.wrongCredentials {
            state.error = L.Onboarding.wrongCredentials
            state.password = ""
        } catch {
            state.error = L.General.somethingWentWrong
            state.password = ""
        }
    }
    
    private func setEmail(_ email: String) {
        state.email = email
    }
    
    private func setPassword(_ password: String) {
        state.isValidEmail = isValidEmail(state.email)
        state.password = password
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return pred.evaluate(with: email)
    }
    
    private func registerUser() {
        flowController?.registerUser()
    }
}
