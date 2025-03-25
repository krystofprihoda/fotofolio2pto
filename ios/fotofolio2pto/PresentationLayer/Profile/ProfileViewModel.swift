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
    
    @LazyInjected private var getUserDataFromUsernameUseCase: GetUserDataFromUsernameUseCase
    @LazyInjected private var getUserPortfoliosUseCase: GetUserPortfoliosUseCase
    
    private weak var flowController: ProfileFlowController?
    
    // MARK: Init
    
    init(
        flowController: ProfileFlowController?,
        signedInUserId: String,
        displayedUser: String,
        showDismiss: Bool = false
    ) {
        self.flowController = flowController
        super.init()
        state.displayedUser = displayedUser
        state.signedInUserId = signedInUserId
        state.showDismiss = showDismiss
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
        var signedInUserId = ""
        var displayedUser = ""
        var isProfileOwner: Bool { signedInUserId == displayedUser }
        var userData: User? = nil
        var portfolios: [Portfolio] = []
        var showDismiss = false
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case fetchProfileData
        case sendMessage
        case showProfileSettings
        case createNewPortfolio
        case goBack
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .fetchProfileData: await fetchProfileData()
            case .sendMessage: sendMessage()
            case .showProfileSettings: showProfileSettings()
            case .createNewPortfolio: createNewPortfolio()
            case .goBack: goBack()
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
        flowController?.sendMessage(from: state.signedInUserId, to: state.displayedUser)
    }
    
    private func showProfileSettings() {
        guard let userData = state.userData else { return }
        flowController?.showProfileSettings(userData: userData, portfolios: state.portfolios)
    }
    
    private func createNewPortfolio() {
        guard let userData = state.userData else { return }
        flowController?.showCreateNewPortfolio(authorUsername: userData.username)
    }
    
    private func goBack() {
        flowController?.navigationController.popViewController(animated: true)
    }
}
