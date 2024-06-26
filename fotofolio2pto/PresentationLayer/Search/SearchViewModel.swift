//
//  SearchViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI
import Resolver

public enum SearchOption: String, CaseIterable {
    case username = "Uživatelské jméno"
    case location = "Poloha"
}

final class SearchViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    private var searchTask: Task<Void, Error>?
    
    // MARK: Dependencies
    
    @LazyInjected private var getUsersFromQueryUseCase: GetUsersFromQueryUseCase
    
    private weak var flowController: SearchFlowController?
    
    // MARK: Init
    
    init(
        flowController: SearchFlowController?,
        signedInUser: String
    ) {
        self.flowController = flowController
        super.init()
        state.signedInUser = signedInUser
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: State
    
    struct State {
        var signedInUser = ""
        var searchOption: SearchOption = .username
        var textInput: String = ""
        var searchResults: [User] = []
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case setSearchOption(SearchOption)
        case setTextInput(String)
        case search
        case showProfile(of: User)
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .setSearchOption(let option): setSearchOption(option)
            case .setTextInput(let input): setTextInput(input)
            case .search: search()
            case .showProfile(let user): showProfile(of: user)
            }
        })
    }
    
    // MARK: Additional methods
    
    private func setSearchOption(_ option: SearchOption) {
        state.searchOption = option
    }
    
    private func setTextInput(_ input: String) {
        state.textInput = input
    }
    
    private func search() {
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.3))
                let results = try await getUsersFromQueryUseCase.execute(query: state.textInput, type: state.searchOption)
                state.searchResults = results.filter({ $0.username != state.signedInUser })
            } catch {
                
            }
        }
    }
    
    private func showProfile(of user: User) {
        flowController?.showProfile(of: user)
    }
}
