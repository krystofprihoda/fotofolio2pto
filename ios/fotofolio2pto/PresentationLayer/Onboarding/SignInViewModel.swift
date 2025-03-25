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
            try await getUserData(userId: authDetails.uid, token: authDetails.token)
            flowController?.signIn(uid: authDetails.uid)
        } catch {
            state.error = "Špatné přihlašovací údaje."
            state.password = ""
        }
    }
    
    func getUserData(userId: String, token: String) async throws {
        guard let url = URL(string: "http://0.0.0.0:8080/user/\(userId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for HTTP response errors
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "ServerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to obtain user data"])
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
