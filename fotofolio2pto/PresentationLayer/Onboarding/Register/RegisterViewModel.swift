//
//  RegisterViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 04.03.2025.
//

import Resolver
import SwiftUI
import OSLog

internal enum RegisterStageEnum {
    case nameAndEmail //location
    case username
    case password
    case isCreator
    case creatorDetails
    case done
}

final class RegisterViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: Stored properties
    
    @LazyInjected private var checkEmailAddressAvailableUseCase: CheckEmailAddressAvailableUseCase
    @LazyInjected private var checkUsernameAvailableUseCase: CheckUsernameAvailableUseCase
    
    private var currentTask: Task<(), Never>?
    
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private let usernameRegex = "^[a-z0-9_.]+$"
    private let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*_+:.?])[A-Za-z0-9!@#$%^&*_+:.?]{8,}$"

    
    // MARK: Dependencies
    
    private weak var flowController: RegisterFlowController?
    
    // MARK: Init
    
    init(
        flowController: RegisterFlowController?
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
        var stage: RegisterStageEnum = .nameAndEmail
        var name = ""
        var email = ""
        var emailVerified = false
        var emailError = ""
        var username = ""
        var usernameVerified = false
        var usernameError = ""
        var firstPassword = ""
        var firstPasswordError = ""
        var isFirstPasswordHidden = true
        var secondPassword = ""
        var secondPasswordError = ""
        var isSecondPasswordHidden = true
        var passwordsVerified = false
        var isCreator = false
        var isCreatingUser = false
        var userCreated = false
        var hideOnboardingTitle = false
        var showSkeleton = false
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case onNameChanged(String)
        case onEmailChanged
        case onEmailInput(String)
        case onNameAndEmailNextTap
        case onUsernameChanged
        case onUsernameInput(String)
        case onUsernameNextTap
        case setPassword(isFirst: Bool, String)
        case onPasswordChanged(isFirst: Bool)
        case onPasswordToggleVisibility(isFirst: Bool)
        case onPasswordNextTap
        case setIsCreator(to: Bool)
        case onCreatorNextTap
        case onCreatorDetailsNextTap
        case goBack(to: RegisterStageEnum)
        case dismissRegistration
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .onNameChanged(let name): setName(to: name)
            case .onEmailChanged: await verifyEmail()
            case .onEmailInput(let email): setEmail(email)
            case .onNameAndEmailNextTap: await checkEmailExistanceAndContinue()
            case .onUsernameChanged: await verifyUsername()
            case .onUsernameInput(let username): setUsername(username)
            case .onUsernameNextTap: await checkUsernameExistanceAndContinue()
            case .setPassword(let isFirst, let password): setPassword(isFirst: isFirst, password)
            case .onPasswordChanged(let isFirst): isFirst ? await verifyFirstPassword() : await verifySecondPassword()
            case .onPasswordToggleVisibility(let isFirst): togglePasswordVisibility(isFirst: isFirst)
            case .onPasswordNextTap: await setPasswordAndContinue()
            case .setIsCreator(let value): setIsCreator(to: value)
            case .onCreatorNextTap: state.isCreator ? continueToCreatorDetails() : await finalizeOnboarding()
            case .onCreatorDetailsNextTap: await finalizeOnboarding()
            case .goBack(let stage): setStageTo(stage)
            case .dismissRegistration: dismissRegistration()
            }
        })
    }
    
    // MARK: Additional methods
    
    private func verifyEmail() async {
        cancelTask()
        currentTask = executeTask(Task {
            do {
                try await Task.sleep(nanoseconds: 600_000_000)
                
                guard isValidEmail(state.email) else {
                    state.emailError = L.Onboarding.invalidEmailFormat
                    state.emailVerified = false
                    return
                }
                
                state.emailError = ""
                state.emailVerified = true
            } catch { Logger.app.error("[FAIL] \(#file) • \(#line) • \(#function) | Task failed: \(error)") }
        })
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return pred.evaluate(with: email)
    }
    
    private func setEmail(_ email: String) {
        state.email = email.lowercased()
    }
    
    private func setName(to name: String) {
        state.name = name
    }
    
    private func cancelTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    private func checkEmailExistanceAndContinue() async {
        state.showSkeleton = true
        defer { state.showSkeleton = false }
        
        do {
            try await checkEmailAddressAvailableUseCase.execute(state.email)
        } catch ObjectError.emailAlreadyTaken {
            state.emailError = L.Onboarding.emailAddressTaken
            return
        } catch { }
        
        state.emailError = ""
        state.stage = .username
    }
    
    private func setUsername(_ username: String) {
        state.username = username.lowercased()
    }
    
    private func togglePasswordVisibility(isFirst: Bool) {
        if isFirst {
            state.isFirstPasswordHidden.toggle()
            return
        }
        
        state.isSecondPasswordHidden.toggle()
    }
    
    private func checkUsernameExistanceAndContinue() async {
        state.showSkeleton = true
        defer { state.showSkeleton = false }
        
        guard isValidUsername(state.username) else {
            state.usernameError = L.Onboarding.supportedUsernameChars
            return
        }
        
        do {
            try await checkUsernameAvailableUseCase.execute(state.username)
        } catch ObjectError.usernameAlreadyTaken {
            state.usernameError = L.Onboarding.usernameTaken
            return
        } catch { }
        
        state.usernameError = ""
        state.stage = .password
    }
    
    private func verifyUsername() async {
        cancelTask()
        currentTask = executeTask(Task {
            do {
                try await Task.sleep(nanoseconds: 600_000_000)
                
                guard isValidUsername(state.username) else {
                    state.usernameError = L.Onboarding.supportedUsernameChars
                    state.usernameVerified = false
                    return
                }
                
                state.usernameError = ""
                state.usernameVerified = true
            } catch { Logger.app.error("[FAIL] \(#file) • \(#line) • \(#function) | Task failed: \(error)") }
        })
    }
    
    private func verifyFirstPassword() async {
        cancelTask()
        currentTask = executeTask(Task {
            do {
                try await Task.sleep(nanoseconds: 600_000_000)
                
                guard isValidPassword(state.firstPassword) else {
                    state.firstPasswordError = L.Onboarding.invalidPasswordFormat
                    return
                }
                
                state.firstPasswordError = ""
                
                if !state.secondPassword.isEmpty { await verifySecondPassword() }
            } catch { Logger.app.error("[FAIL] \(#file) • \(#line) • \(#function) | Task failed: \(error)") }
        })
    }
    
    private func verifySecondPassword() async {
        cancelTask()
        currentTask = executeTask(Task {
            do {
                try await Task.sleep(nanoseconds: 600_000_000)
                
                guard state.firstPassword == state.secondPassword else {
                    state.secondPasswordError = L.Onboarding.passwordMismatch
                    return
                }
                
                state.secondPasswordError = ""
                state.passwordsVerified = true
            } catch { Logger.app.error("[FAIL] \(#file) • \(#line) • \(#function) | Task failed: \(error)") }
        })
    }
    
    func isValidUsername(_ username: String) -> Bool {
        guard !username.isEmpty else { return false }
        
        let pred = NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return pred.evaluate(with: username)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        guard !password.isEmpty else { return false }
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private func setPassword(isFirst: Bool, _ password: String) {
        if isFirst {
            state.firstPassword = password
            return
        }
        
        state.secondPassword = password
    }
    
    private func setPasswordAndContinue() async {
        state.showSkeleton = true
        defer { state.showSkeleton = false }
        
        // pwd usecase
        // try await checkEmailAddressAvailableUseCase.execute(state.email)
        
        state.firstPasswordError = ""
        state.secondPasswordError = ""
        state.stage = .isCreator
    }
    
    private func continueToCreatorDetails() {
        setStageTo(.creatorDetails)
        setIsCreator(to: true)
    }
    
    private func finalizeOnboarding() async {
        // register user usecase
        
        state.stage = .done
        state.isCreatingUser = true
        state.hideOnboardingTitle = true
        
        defer {
            state.isCreatingUser = false
            state.hideOnboardingTitle = false
        }
        
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            state.userCreated = true
            try await Task.sleep(nanoseconds: 1_000_000_000)
            dismissRegistration()
        } catch { }
    }
    
    private func setIsCreator(to value: Bool) {
        state.isCreator = value
    }
    
    private func setStageTo(_ stage: RegisterStageEnum) {
        state.stage = stage
    }
    
    private func dismissRegistration() {
        flowController?.navigationController.popViewController(animated: true)
    }
}
