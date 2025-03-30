//
//  PortfolioDetailViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 29.03.2025.
//

import Resolver
import SwiftUI

public protocol PortfolioSelectionFlowDelegate: AnyObject {
    func unflagPortfolio(_ portfolioId: String)
    func showProfile(creatorId: String) async
    func sendMessage(toCreatorWithId creatorId: String) async
}

final class PortfolioDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: Stored properties
    
    private weak var portfolioSelectionFlowDelegate: PortfolioSelectionFlowDelegate?

    // MARK: Dependencies

    @LazyInjected private var readUserDataByCreatorIdUseCase: ReadUserDataByCreatorIdUseCase
    @LazyInjected private var readCreatorDataUseCase: ReadCreatorDataUseCase

    // MARK: Init
    
    init(
        portfolio: Portfolio,
        portfolioSelectionFlowDelegate: PortfolioSelectionFlowDelegate?
    ) {
        self.portfolioSelectionFlowDelegate = portfolioSelectionFlowDelegate
        
        super.init()
        
        state.portfolio = portfolio
        
        executeTask(Task {
            await fetchAuthorData()
        })
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State {
        var isLoading: Bool = false
        var portfolio: Portfolio! = nil
        var userData: User? = nil
        var creatorData: Creator? = nil
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case showProfile
        case sendMessage
        case unflagPortfolio
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task{
            switch intent {
            case .showProfile: await portfolioSelectionFlowDelegate?.showProfile(creatorId: state.portfolio.creatorId)
            case .sendMessage: await portfolioSelectionFlowDelegate?.sendMessage(toCreatorWithId: state.portfolio.creatorId)
            case .unflagPortfolio: portfolioSelectionFlowDelegate?.unflagPortfolio(state.portfolio.id)
            }
        })
    }

    // MARK: Additional methods

    private func fetchAuthorData() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            state.userData = try await readUserDataByCreatorIdUseCase.execute(creatorId: state.portfolio.creatorId)
            state.creatorData = try await readCreatorDataUseCase.execute(id: state.portfolio.creatorId)
        } catch {
            
        }
    }
}
