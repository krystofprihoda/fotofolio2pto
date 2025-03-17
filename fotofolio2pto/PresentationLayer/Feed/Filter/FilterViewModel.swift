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
        state.selectedTags = preselected
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State {
        var searchInput: String = ""
        var filteredTags: [String] = photoCategories
        var selectedTags: [String] = []
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case dismiss
        case addTag(String)
        case removeTag(String)
        case setSearchInput(String)
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .dismiss: dismiss()
            case .addTag(let tag): await addTag(tag)
            case .removeTag(let tag): await removeTag(tag)
            case .setSearchInput(let input): setTagInput(input)
            }
        })
    }

    // MARK: Additional methods
    
    private func addTag(_ tag: String) async {
        guard !state.selectedTags.contains(tag), state.selectedTags.count < 5 else { return }
        state.selectedTags.append(tag)
        state.searchInput = ""
        
        cancelTask()
        currentTask = executeTask(Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                await flowController?.filterFeedFlowDelegate?.filterFeedPortfolios(state.selectedTags)
            } catch {
                Logger.app.error("[FAIL] \(#file) • \(#line) • \(#function) | Task failed: \(error)")
            }
        })
    }
    
    private func removeTag(_ tag: String) async {
        state.selectedTags.removeAll(where: { $0 == tag })
        
        cancelTask()
        currentTask = executeTask(Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                await flowController?.filterFeedFlowDelegate?.removeFilterTag(tag)
            } catch {
                Logger.app.error("[FAIL] \(#file) • \(#line) • \(#function) | Task failed: \(error)")
            }
        })
    }
    
    private func setTagInput(_ input: String) {
        state.searchInput = input
        
        if state.searchInput.isEmpty {
            state.filteredTags = photoCategories
            return
        }
        
        state.filteredTags = photoCategories.filter { $0.localizedCaseInsensitiveContains(state.searchInput) }
    }
    
    private func cancelTask() {
        currentTask?.cancel()
        currentTask = nil
    }

    private func dismiss() {
        flowController?.dismissFilter()
    }
}
