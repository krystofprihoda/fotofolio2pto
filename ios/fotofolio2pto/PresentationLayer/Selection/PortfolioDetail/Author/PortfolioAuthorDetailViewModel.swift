//
//  PortfolioAuthorDetailViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 29.03.2025.
//

import Resolver
import SwiftUI

final class PortfolioAuthorDetailViewModel: BaseViewModel, ViewModel, ObservableObject {
    
    // MARK: Stored properties
    
    private let creatorId: String
    
    let unflagPortfolio: () -> Void
    let showProfile: () -> Void
    let sendMessage: () -> Void

    // MARK: Dependencies

    @LazyInjected private var readUserDataByCreatorIdUseCase: ReadUserDataByCreatorIdUseCase
    @LazyInjected private var readCreatorDataUseCase: ReadCreatorDataUseCase

    // MARK: Init
    
    init(
        creatorId: String,
        unflagPortfolio: @escaping () -> Void,
        showProfile: @escaping () -> Void,
        sendMessage: @escaping () -> Void
    ) {
        self.creatorId = creatorId
        self.unflagPortfolio = unflagPortfolio
        self.showProfile = showProfile
        self.sendMessage = sendMessage
        
        super.init()
        
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
        var isLoading: Bool = true
        var userData: User? = nil
        var creatorData: Creator? = nil
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {}

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {}

    // MARK: Additional methods

    private func fetchAuthorData() async {
        defer { state.isLoading = false }
        do {
            state.userData = try await readUserDataByCreatorIdUseCase.execute(creatorId: creatorId)
            state.creatorData = try await readCreatorDataUseCase.execute(id: creatorId)
        } catch {
            
        }
    }
}
