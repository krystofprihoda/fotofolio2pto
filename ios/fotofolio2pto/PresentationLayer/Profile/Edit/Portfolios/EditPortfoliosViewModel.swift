//
//  EditPortfoliosViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 06.04.2025.
//


import Foundation
import Resolver
import SwiftUI

final class EditPortfoliosViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    @LazyInjected private var readCreatorDataUseCase: ReadCreatorDataUseCase
    @LazyInjected private var removePortfolioUseCase: RemovePortfolioUseCase

    private weak var flowController: ProfileFlowController?

    // MARK: Init

    init(
        flowController: ProfileFlowController?,
        creatorId: String,
        portfolios: [Portfolio]
    ) {
        self.flowController = flowController
        super.init()
        state.creatorId = creatorId
        state.portfolios = portfolios
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State: Equatable {
        var isLoading = false
        var creatorId = ""
        var portfolios: [Portfolio] = []
        var alertData: AlertData? = nil
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case editPorfolio(Portfolio)
        case removePortfolio(String)
        case onAlertDataChanged(AlertData?)
        case cancel
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .editPorfolio(let portfolio): presentEditPortfolio(portfolio)
            case .removePortfolio(let id): tapRemovePortfolio(id: id)
            case .onAlertDataChanged(let alertData): setAlertData(alertData)
            case .cancel: cancelEdit()
            }
        })
    }

    // MARK: Additional methods
    
    private func presentEditPortfolio(_ portfolio: Portfolio) {
        guard !state.creatorId.isEmpty else { return }
        flowController?.showEditPortfolio(portfolio, creatorId: state.creatorId, updatePortfolioProfileFlowDelegate: self)
    }
    
    private func tapRemovePortfolio(id: String) {
        state.alertData = .init(
            title: L.Profile.deletePortfolio,
            message: nil,
            primaryAction: .init(
                title: L.Profile.cancel,
                style: .cancel,
                handler: { [weak self] in
                    self?.state.alertData = nil
                }
            ),
            secondaryAction: .init(
                title: L.Profile.yesRemove,
                style: .destruction,
                handler: { [weak self] in
                    self?.removePortfolio(id: id)
                }
            )
        )
    }
    
    private func removePortfolio(id: String) {
        state.portfolios = state.portfolios.filter { $0.id != id }
        
        executeTask(Task {
            do {
                try await removePortfolioUseCase.execute(id: id)
            } catch {
                
            }
        })
    }
    
    private func setAlertData(_ alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func cancelEdit() {
        dismissView()
    }
    
    private func dismissView() {
        flowController?.navigationController.popViewController(animated: true)
    }
}

extension EditPortfoliosViewModel: UpdatePortfolioProfileFlowDelegate {
    func updatePortfolios(with portfolio: Portfolio) {
        guard let idx = state.portfolios.firstIndex(where: { $0.id == portfolio.id }) else { return }
        state.portfolios[idx] = portfolio
    }
}
