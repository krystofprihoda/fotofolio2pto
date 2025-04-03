//
//  SearchViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI
import Resolver

enum SearchIntent {
    case profile
    case chat
}

final class SearchViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    private var searchTask: Task<Void, Error>?
    
    // MARK: Dependencies
    
    @LazyInjected private var readUsersFromQueryUseCase: ReadUsersFromQueryUseCase
    
    private weak var searchFlowController: SearchFlowController?
    private weak var messagesFlowController: MessagesFlowController?
    
    // MARK: Init
    
    init(
        searchFlowController: SearchFlowController? = nil,
        messagesFlowController: MessagesFlowController? = nil,
        signedInUserId: String,
        searchIntent: SearchIntent
    ) {
        self.searchFlowController = searchFlowController
        self.messagesFlowController = messagesFlowController
        super.init()
        state.signedInUserId = signedInUserId
        state.intent = searchIntent
        
        if searchIntent == .chat { state.showDismiss = true }
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
    }
    
    // MARK: State
    
    struct State {
        var signedInUserId = ""
        var intent: SearchIntent = .profile
        var textInput: String = ""
        var searchResults: [User] = []
        var showDismiss = false
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case setTextInput(String)
        case search
        case onResultTap(of: User)
        case goBack
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .setTextInput(let input): setTextInput(input)
            case .search: search()
            case .onResultTap(let user): onResultTap(of: user)
            case .goBack: dismissScreen()
            }
        })
    }
    
    // MARK: Additional methods
    
    private func setTextInput(_ input: String) {
        state.textInput = input
    }
    
    private func search() {
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.3))
                state.searchResults = try await readUsersFromQueryUseCase.execute(query: state.textInput.lowercased())
            } catch {
                
            }
        }
    }
    
    private func onResultTap(of user: User) {
        switch state.intent {
        case .profile:
            searchFlowController?.showProfile(of: user)
        case .chat:
            messagesFlowController?.showChat(senderId: state.signedInUserId, receiverId: user.id)
        }
    }
    
    private func dismissScreen() {
        switch state.intent {
        case .profile:
            searchFlowController?.navigationController.popViewController(animated: true)
        case .chat:
            messagesFlowController?.navigationController.popViewController(animated: true)
        }
    }
}
