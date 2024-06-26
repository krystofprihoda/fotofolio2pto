//
//  SelectionViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import Resolver

final class SelectionViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    @LazyInjected private var getFlaggedPortfoliosUseCase: GetFlaggedPortfoliosUseCase
    @LazyInjected private var unflagAllPortfoliosUseCase: UnflagAllPortfoliosUseCase
    @LazyInjected private var unflagPortfolioUseCase: UnflagPortfolioUseCase
    
    private weak var flowController: SelectionFlowController?
    
    // MARK: Init
    
    init(
        flowController: SelectionFlowController?
    ) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task { await getFlaggedPortfolios() })
    }
    
    // MARK: State
    
    struct State {
        var isLoading = false
        var portfolios: [Portfolio] = []
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case getFlagged
        case removeAllFlagged
        case removeFromFlagged(Int)
        case showProfile(User)
        case sendMessage(to: User)
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .getFlagged: await getFlaggedPortfolios()
            case .removeAllFlagged: removeAllFlagged()
            case .removeFromFlagged(let id): removeFromFlagged(id: id)
            case .showProfile(let user): showProfile(user: user)
            case .sendMessage(let user): sendMessage(to: user)
            }
        })
    }
    
    // MARK: Additional methods
    
    private func getFlaggedPortfolios() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            state.portfolios = try await getFlaggedPortfoliosUseCase.execute()
        } catch {
            
        }
    }
    
    private func removeAllFlagged() {
        do {
            try unflagAllPortfoliosUseCase.execute()
            state.portfolios = []
        } catch {
            
        }
    }
    
    private func removeFromFlagged(id: Int) {
        do {
            try unflagPortfolioUseCase.execute(id: id)
            state.portfolios.removeAll(where: { $0.id == id })
        } catch {
            
        }
    }
    
    private func showProfile(user: User) {
        flowController?.showProfile(user: user)
    }
    
    private func sendMessage(to user: User) {
        flowController?.sendMessage(to: user)
    }
}
