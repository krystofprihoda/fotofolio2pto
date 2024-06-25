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
    // UCs
    
    private weak var flowController: ProfileFlowController?
    
    // MARK: Init
    
    init(
        flowController: ProfileFlowController?,
        user: String,
        isProfileOwner: Bool = false
    ) {
        self.flowController = flowController
        super.init()
        state.username = user
        state.isProfileOwner = isProfileOwner
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        fetchUserInfo()
        fetchPortfolios()
    }
    
    // MARK: State
    
    struct State {
        var isLoadingUser = false
        var isLoadingPortfolios = false
        var isProfileOwner = false
        var username = ""
        var userData: User? = .dummy2
        var portfolios: [Portfolio] = [.dummyPortfolio2, .dummyPortfolio3, .dummyPortfolio5]
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case fetchUserInfo
        case fetchProfilePortofolios
        case signOut
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .fetchUserInfo: fetchUserInfo()
            case .fetchProfilePortofolios: fetchPortfolios()
            case .signOut: signOut()
            }
        })
    }
    
    // MARK: Additional methods
    
    private func fetchUserInfo() {
        
    }
    
    private func fetchPortfolios() {
        
    }
    
    private func signOut() {
        logOutUseCase.execute()
        flowController?.flowDelegate?.signOut()
    }
}
