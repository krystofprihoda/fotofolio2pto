//
//  SearchViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation

enum SearchOption: String, CaseIterable {
    case username = "Uživatelské jméno"
    case location = "Poloha"
}

final class SearchViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    // UCs
    
    private weak var flowController: SearchFlowController?
    
    // MARK: Init
    
    init(
        flowController: SearchFlowController?
    ) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: State
    
    struct State {
        var searchOption: SearchOption = .username
        var textInput: String = ""
        var isSearching: Bool = false
        var searchResults: [User] = []
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case setSearchOption(SearchOption)
        case setTextInput(String)
        case setIsSearching(Bool)
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .setSearchOption(let option): setSearchOption(option)
            case .setTextInput(let input): setTextInput(input)
            case .setIsSearching(let value): setIsSearching(value)
            }
        })
    }
    
    // MARK: Additional methods
    
    private func setSearchOption(_ option: SearchOption) {
        state.searchOption = option
    }
    
    private func setIsSearching(_ value: Bool) {
        state.isSearching = value
    }
    
    private func setTextInput(_ input: String) {
        state.textInput = input
    }
}
