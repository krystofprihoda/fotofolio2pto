//
//  GiveRatingViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 07.04.2025.
//

import Resolver
import SwiftUI

final class GiveRatingViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    @LazyInjected private var giveRatingUseCase: GiveRatingUseCase

    private weak var flowController: ProfileFlowController?

    // MARK: Init

    init(
        flowController: ProfileFlowController?,
        receiverId: String
    ) {
        self.flowController = flowController
        super.init()
        state.receiverId = receiverId
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State {
        var isLoading: Bool = false
        var receiverId: String = ""
        var rating: Int = 4
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case setRating(Int)
        case giveRating
        case goBack
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .setRating(let value): setRating(value)
            case .giveRating: await giveRating()
            case .goBack: goBack()
            }
        })
    }

    // MARK: Additional methods
    
    private func setRating(_ value: Int) {
        state.rating = value
    }
    
    private func giveRating() async {
        guard !state.receiverId.isEmpty else { return }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            let average = try await giveRatingUseCase.execute(receiverId: state.receiverId, rating: state.rating)
            // assign average to profileview using flowdelegate
            goBack()
        } catch {
            
        }
    }

    private func goBack() {
        flowController?.navigationController.popViewController(animated: true)
    }
}
