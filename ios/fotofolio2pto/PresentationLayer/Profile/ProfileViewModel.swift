//
//  ProfileViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI
import Resolver

public protocol UpdateProfileFlowDelegate: AnyObject {
    func fetchProfileData(refresh: Bool) async
}

final class ProfileViewModel: BaseViewModel, ViewModel, ObservableObject, UpdateProfileFlowDelegate {
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
        
        executeTask(Task { await fetchProfileData() })
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
        var isRefreshing = false
        var signedInUserId = ""
        var displayedUserId = ""
        var isProfileOwner: Bool { signedInUserId == displayedUserId }
        var userData: User? = nil
        var creatorData: Creator? = nil
        var portfolios: [Portfolio] = []
        var showDismiss = false
        var toastData: ToastData? = nil
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case fetchProfileData(isRefreshing: Bool)
        case sendMessage
        case showProfileSettings
        case createNewPortfolio
        case giveRating
        case setToastData(ToastData?)
        case goBack
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .fetchProfileData(let isRefreshing): await fetchProfileData(refresh: isRefreshing)
            case .sendMessage: sendMessage()
            case .showProfileSettings: showProfileSettings()
            case .createNewPortfolio: createNewPortfolio()
            case .giveRating: giveRating()
            case .setToastData(let toast): setToastData(toast)
            case .goBack: goBack()
            }
        })
    }
    
    // MARK: Additional methods
    
    private func setToastData(_ toast: ToastData?) {
        state.toastData = toast
    }
    
    func fetchProfileData(refresh: Bool = false) async {
        if refresh {
            state.isRefreshing = true
        } else {
            state.isLoading = true
        }
        
        defer {
            if refresh {
                state.isRefreshing = false
            } else {
                state.isLoading = false
            }
        }
        
        do {
            state.userData = try await readUserByIdUseCase.execute(id: state.displayedUserId)
            
            try await fetchCreatorDataAndPortfolios()
        } catch {
            state.toastData = .init(message: L.Profile.profileLoadFailed, type: .error)
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
        guard let creatorId = state.userData?.creatorId else { return }
        flowController?.showCreateNewPortfolio(creatorId: creatorId)
    }
    
    private func giveRating() {
        flowController?.showGiveRating(receiverId: state.displayedUserId)
    }
    
    private func goBack() {
        flowController?.navigationController.popViewController(animated: true)
    }
}
