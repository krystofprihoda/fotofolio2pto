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
    
    @LazyInjected private var readUserByIdUseCase: ReadUserByIdUseCase
    @LazyInjected private var readCreatorDataUseCase: ReadCreatorDataUseCase
    @LazyInjected private var readCreatorPortfoliosUseCase: ReadCreatorPortfoliosUseCase
    
    private weak var flowController: ProfileFlowController?
    
    // MARK: Init
    
    init(
        flowController: ProfileFlowController?,
        signedInUserId: String,
        displayedUserId: String,
        showDismiss: Bool = false
    ) {
        self.flowController = flowController
        super.init()
        state.displayedUserId = displayedUserId
        state.signedInUserId = signedInUserId
        state.showDismiss = showDismiss
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        executeTask(Task { await fetchProfileData() })
    }
    
    // MARK: State
    
    struct State {
        var isLoading = false
        var signedInUserId = ""
        var displayedUserId = ""
        var isProfileOwner: Bool { signedInUserId == displayedUserId }
        var userData: User? = nil
        var creatorData: Creator? = nil
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
            state.userData = try await readUserByIdUseCase.execute(id: state.displayedUserId)
            
            try await fetchCreatorDataAndPortfolios()
        } catch {
            
        }
    }
    
    private func fetchCreatorDataAndPortfolios() async throws {
        guard let creatorId = state.userData?.creatorId else { return }
        
        state.portfolios = try await readCreatorPortfoliosUseCase.execute(creatorId: creatorId)
        state.creatorData = try await readCreatorDataUseCase.execute(id: creatorId)
    }
    
    private func sendMessage() {
        flowController?.sendMessage(from: state.signedInUserId, to: state.displayedUserId)
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
