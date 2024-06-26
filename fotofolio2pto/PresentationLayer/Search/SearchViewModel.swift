//
//  SearchViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI

enum SearchOption: String, CaseIterable {
    case username = "Uživatelské jméno"
    case location = "Poloha"
}

final class SearchViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    private var searchTask: Task<Void, Error>?
    
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
        case search
        case showProfile(of: User)
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .setSearchOption(let option): setSearchOption(option)
            case .setTextInput(let input): setTextInput(input)
            case .setIsSearching(let value): withAnimation { setIsSearching(value) }
            case .search: search()
            case .showProfile(let user): showProfile(of: user)
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
    
    private func search() {
        searchTask?.cancel()
        
        searchTask = Task {
            try await Task.sleep(for: .seconds(0.4))
            state.searchResults = Int.random(in: 0...1) > 0 ? [.dummy1] : [.dummy2, .dummy4]
        }
    }
    
    private func showProfile(of user: User) {
        flowController?.showProfile(of: user)
    }
}
