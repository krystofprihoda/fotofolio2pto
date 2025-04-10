//
//  FilterViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation
import SwiftUI
import OSLog

final class FilterViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    // UCs

    private weak var flowController: FeedFlowController?
    private var currentTask: Task<(), Never>?

    // MARK: Init

    init(
        flowController: FeedFlowController?,
        with preselected: [String] = []
    ) {
        self.flowController = flowController
        super.init()
        state.selectedCategories = preselected
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State {
        var searchInput: String = ""
        var filteredCategories: [String] = photoCategories
        var selectedCategories: [String] = []
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case dismiss
        case addCategory(String)
        case removeCategory(String)
        case setSearchInput(String)
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .dismiss: dismiss()
            case .addCategory(let category): await addCategory(category)
            case .removeCategory(let category): await removeCategory(category)
            case .setSearchInput(let input): setTagInput(input)
            }
        })
    }

    // MARK: Additional methods
    
    private func addCategory(_ category: String) async {
        guard !state.selectedCategories.contains(category), state.selectedCategories.count < 5 else { return }
        state.selectedCategories.append(category)
        state.searchInput = ""
        
        cancelTask()
        currentTask = executeTask(Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                await flowController?.filterFeedDelegate?.filterFeedPortfolios(state.selectedCategories)
            } catch { }
        })
    }
    
    private func removeCategory(_ category: String) async {
        cancelTask()
        currentTask = executeTask(Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                state.selectedCategories.removeAll(where: { $0 == category })
                await flowController?.filterFeedDelegate?.removeFilterCategory(category)
            } catch { }
        })
    }
    
    private func setTagInput(_ input: String) {
        state.searchInput = input
        
        if state.searchInput.isEmpty {
            state.filteredCategories = photoCategories
            return
        }
        
        state.filteredCategories = photoCategories.filter { $0.localizedCaseInsensitiveContains(state.searchInput) }
    }
    
    private func cancelTask() {
        currentTask?.cancel()
        currentTask = nil
    }

    private func dismiss() {
        flowController?.dismissFilter()
    }
}
