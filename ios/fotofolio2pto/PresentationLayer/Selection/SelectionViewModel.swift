//
//  SelectionViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import Resolver

final class SelectionViewModel: BaseViewModel, ViewModel, ObservableObject, PortfolioSelectionFlowDelegate {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    @LazyInjected private var readFlaggedPortfoliosUseCase: ReadFlaggedPortfoliosUseCase
    @LazyInjected private var unflagAllPortfoliosUseCase: UnflagAllPortfoliosUseCase
    @LazyInjected private var unflagPortfolioUseCase: UnflagPortfolioUseCase
    @LazyInjected private var readUserDataByCreatorIdUseCase: ReadUserDataByCreatorIdUseCase
    
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
        executeTask(Task { await getFlaggedPortfoliosData() })
    }
    
    // MARK: State
    
    struct State {
        var isLoading = false
        var portfolios: [Portfolio] = []
        var alertData: AlertData? = nil
        var toastData: ToastData? = nil
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case getFlagged
        case tapRemoveAllFlagged
        case tapRemoveFromFlagged(String)
        case showProfile(creatorId: String)
        case sendMessage(toCreatorWithId: String)
        case onAlertDataChanged(AlertData?)
        case setToastData(ToastData?)
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .getFlagged: await getFlaggedPortfoliosData()
            case .tapRemoveAllFlagged: tapRemoveAllFlagged()
            case .tapRemoveFromFlagged(let id): tapRemoveFromFlagged(id: id)
            case .showProfile(let creatorId): await showProfile(creatorId: creatorId)
            case .sendMessage(let creatorId): await sendMessage(toCreatorWithId: creatorId)
            case .onAlertDataChanged(let alertData): onAlertDataChanged(alertData: alertData)
            case .setToastData(let toast): setToastData(toast)
            }
        })
    }
    
    // MARK: Additional methods
    
    private func getFlaggedPortfoliosData() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            state.portfolios = try await readFlaggedPortfoliosUseCase.execute()
        } catch {
            state.toastData = .init(message: L.Selection.profileLoadFailed, type: .error)
        }
    }
    
    private func tapRemoveAllFlagged() {
        state.alertData = .init(
            title: L.Selection.removeAllFromSelection,
            message: nil,
            primaryAction: .init(
                title: L.General.cancel,
                style: .cancel,
                handler: { [weak self] in
                    self?.dismissAlert()
                }
            ),
            secondaryAction: .init(
                title: L.Selection.removeAll,
                style: .destruction,
                handler: { [weak self] in
                    self?.removeAllFlagged()
                }
            )
        )
    }
    
    private func removeAllFlagged() {
        unflagAllPortfoliosUseCase.execute()
        state.portfolios = []
        
        state.toastData = .init(message: L.Selection.removedAll, type: .neutral)
        
        flowController?.tabBadgeFlowDelegate?.updateCount(of: .selection, to: 0, animated: false)
    }
    
    private func tapRemoveFromFlagged(id: String) {
        state.alertData = .init(
            title: L.Selection.removePortfolioFromSelection,
            message: nil,
            primaryAction: .init(
                title: L.General.cancel,
                style: .cancel,
                handler: { [weak self] in
                    self?.dismissAlert()
                }
            ),
            secondaryAction: .init(
                title: L.Selection.remove,
                style: .destruction,
                handler: { [weak self] in
                    self?.removeFromFlagged(id: id)
                }
            )
        )
    }
    
    private func onAlertDataChanged(alertData: AlertData?) {
        state.alertData = alertData
    }
    
    private func dismissAlert() {
        state.alertData = nil
    }
    
    private func removeFromFlagged(id: String) {
        unflagPortfolioUseCase.execute(id: id)
        state.portfolios.removeAll(where: { $0.id == id })
        
        state.toastData = .init(message: L.Selection.portfolioRemoved, type: .neutral)
        
        flowController?.tabBadgeFlowDelegate?.updateCount(of: .selection, to: state.portfolios.count, animated: false)
    }
    
    private func setToastData(_ toast: ToastData?) {
        state.toastData = toast
    }
    
    // MARK: Public delegate methods
    
    func showProfile(creatorId: String) async {
        do {
            let user = try await readUserDataByCreatorIdUseCase.execute(creatorId: creatorId)
            flowController?.showProfile(user: user)
        } catch {
            state.toastData = .init(message: L.Selection.profileLoadFailed, type: .error)
        }
    }
    
    func sendMessage(toCreatorWithId creatorId: String) async {
        do {
            let user = try await readUserDataByCreatorIdUseCase.execute(creatorId: creatorId)
            flowController?.sendMessage(to: user)
        } catch {
            state.toastData = .init(message: L.Selection.profileLoadFailed, type: .error)
        }
    }
    
    func unflagPortfolio(_ portfolioId: String) {
        tapRemoveFromFlagged(id: portfolioId)
    }
}
