//
//  RegisterViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 04.03.2025.
//

import Resolver
import SwiftUI

internal enum RegisterStageEnum {
    case nameAndEmail
    case username
    case password
    case location
    case profilePicture
    case isCreator
    case creatorDetails
    case done
}

final class RegisterViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: Stored properties
    
    @LazyInjected private var checkEmailAddressAvailableUseCase: CheckEmailAddressAvailableUseCase
    
    private var currentTask: Task<(), Never>?
    
    private let invalidEmailFormatString = ""
    
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
    
    struct State {
        var stage: RegisterStageEnum = .nameAndEmail
        var email = ""
        var emailVerified = false
        var emailError = ""
        var profilePicture: MyImageEnum? = nil
        var username = ""
        var usernameError = ""
        var name = ""
        var showSkeleton = false
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case onNameChanged(String)
        case onEmailChanged
        case onEmailInput(String)
        case onNameAndEmailNextTap
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .onNameChanged(let name): setName(to: name)
            case .onEmailChanged: await verifyEmail()
            case .onEmailInput(let email): setEmail(email)
            case .onNameAndEmailNextTap: await checkEmailExistanceAndContinue()
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
                
                print("VERIFYING")
                
                state.emailVerified = true
            } catch {
                
            }
        })
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return pred.evaluate(with: email)
    }
    
    private func setEmail(_ email: String) {
        state.email = email
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
        } catch { }
        
        state.emailError = ""
        state.stage = .username
    }
}
