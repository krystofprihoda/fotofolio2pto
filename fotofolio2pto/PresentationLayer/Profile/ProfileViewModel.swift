//
//  ProfileViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI
import Resolver

final class ProfileViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    @LazyInjected private var logOutUseCase: LogoutUseCase
    @LazyInjected private var getUserDataFromUsernameUseCase: GetUserDataFromUsernameUseCase
    @LazyInjected private var getUserPortfoliosUseCase: GetUserPortfoliosUseCase
    
    private weak var flowController: ProfileFlowController?
    
    // MARK: Init
    
    init(
        flowController: ProfileFlowController?,
        signedInUser: String,
        displayedUser: String
    ) {
        self.flowController = flowController
        super.init()
        state.displayedUser = displayedUser
        state.signedInUser = signedInUser
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        if state.userData == nil {
            executeTask(Task { await fetchProfileData() })
        }
    }
    
    // MARK: State
    
    struct State {
        var isLoading = false
        var signedInUser = ""
        var displayedUser = ""
        var isProfileOwner: Bool { signedInUser == displayedUser }
        var userData: User? = nil
        var portfolios: [Portfolio] = []
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case fetchProfileData
        case sendMessage
        case signOut
        case editProfile
        case createNewPortfolio
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .fetchProfileData: await fetchProfileData()
            case .sendMessage: sendMessage()
            case .signOut: signOut()
            case .editProfile: editProfile()
            case .createNewPortfolio: createNewPortfolio()
            }
        })
    }
    
    // MARK: Additional methods
    
    private func fetchProfileData() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            state.userData = try await getUserDataFromUsernameUseCase.execute(state.displayedUser)
            state.portfolios = try await getUserPortfoliosUseCase.execute(username: state.displayedUser)
        } catch {
            
        }
    }
    
    private func sendMessage() {
        flowController?.sendMessage(from: state.signedInUser, to: state.displayedUser)
    }
    
    private func editProfile() {
        guard let userData = state.userData else { return }
        flowController?.showProfileEdit(userData: userData, portfolios: state.portfolios)
    }
    
    private func createNewPortfolio() {
        guard let userData = state.userData else { return }
        flowController?.showCreateNewPortfolio(user: userData)
    }
    
    private func signOut() {
        logOutUseCase.execute()
        flowController?.flowDelegate?.signOut()
    }
}
