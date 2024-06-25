//
//  FilterViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation
import SwiftUI

final class FilterViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    // MARK: Dependencies

    // UCs

    private weak var flowController: FeedFlowController?

    // MARK: Init

    init(
        flowController: FeedFlowController?,
        with filter: [String] = []
    ) {
        self.flowController = flowController
        super.init()
        state.tags = filter
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State {
        var textInput: String = ""
        var tags: [String] = []
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case dismiss
        case addTag
        case removeTag(String)
        case registerTextInput(String)
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .dismiss: dismiss()
            case .addTag: await addTag()
            case .removeTag(let tag): await removeTag(tag)
            case .registerTextInput(let input): registerTextInput(input)
            }
        })
    }

    // MARK: Additional methods
    
    private func addTag() async {
        guard !state.tags.contains(where: { $0 == state.textInput }), state.tags.count < 6 else { return }
        
        withAnimation { state.tags.append(state.textInput) }
        state.textInput = ""
        
        await flowController?.feedFlowDelegate?.filterFeedPortfolios(state.tags)
    }
    
    private func removeTag(_ tag: String) async {
        withAnimation { state.tags.removeAll(where: { $0 == tag }) }
        
        await flowController?.feedFlowDelegate?.removeFilterTag(tag)
    }
    
    private func registerTextInput(_ text: String) {
        state.textInput = text
    }

    private func dismiss() {
        flowController?.dismissFilter()
    }
}
