//
//  ProfileViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI

final class ProfileViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    // UCs
    
    private weak var flowController: ProfileFlowController?
    
    // MARK: Init
    
    init(
        flowController: ProfileFlowController?,
        user: String
    ) {
        self.flowController = flowController
        super.init()
        state.username = user
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        fetchUserInfo()
        fetchPortfolios()
    }
    
    // MARK: State
    
    struct State {
        var isLoadingUser: Bool = false
        var isLoadingPortfolios: Bool = false
        var username: String = ""
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
        print(state.username)
    }
    
    private func fetchPortfolios() {
        print(state.username)
    }
    
    private func signOut() {
        flowController?.flowDelegate?.signOut()
    }
}
