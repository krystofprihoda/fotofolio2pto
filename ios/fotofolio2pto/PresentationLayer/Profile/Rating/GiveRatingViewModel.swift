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

    // MARK: State

    struct State {
        var isLoading: Bool = false
        var toastData: ToastData? = nil
        var receiverId: String = ""
        var rating: Int = 4
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case setRating(Int)
        case giveRating
        case goBack
        case setToastData(ToastData?)
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .setRating(let value): setRating(value)
            case .giveRating: await giveRating()
            case .goBack: goBack()
            case .setToastData(let toast): setToastData(toast)
            }
        })
    }

    // MARK: Additional methods
    
    private func setRating(_ value: Int) {
        state.rating = value
    }
    
    private func setToastData(_ toast: ToastData?) {
        state.toastData = toast
    }
    
    private func giveRating() async {
        guard !state.receiverId.isEmpty else { return }
        
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            try await giveRatingUseCase.execute(receiverId: state.receiverId, rating: state.rating)
            goBack()
        } catch {
            state.toastData = .init(message: L.General.somethingWentWrong, type: .error)
        }
    }

    private func goBack() {
        flowController?.navigationController.popViewController(animated: true)
    }
}
