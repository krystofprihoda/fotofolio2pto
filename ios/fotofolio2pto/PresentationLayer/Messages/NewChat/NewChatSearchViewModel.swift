//
//  NewChatSearchViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation
import Resolver

final class NewChatSearchViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    private var searchTask: Task<Void, Error>?
    
    // MARK: Dependencies

//    @LazyInjected private var createNewChatUseCase: CreateNewChatUseCase
    @LazyInjected private var readUsersFromQueryUseCase: ReadUsersFromQueryUseCase

    private weak var flowController: MessagesFlowController?

    // MARK: Init

    init(
        flowController: MessagesFlowController?,
        sender: String
    ) {
        self.flowController = flowController
        super.init()
        state.sender = sender
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
    }

    // MARK: State

    struct State {
        var isLoading: Bool = false
        var sender = ""
        var textInput = ""
        var searchResults: [User] = []
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case showNewChatWithUser(User)
        case setTextInput(String)
        case search
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .showNewChatWithUser(let user): await showNewChatWithUser(user)
            case .setTextInput(let input): setTextInput(input)
            case .search: search()
            }
        })
    }

    // MARK: Additional methods

    private func showNewChatWithUser(_ receiver: User) async {
        do {
//            let _ = try await createNewChatUseCase.execute(sender: state.sender, receiver: receiver)
            flowController?.showChat(sender: state.sender, receiver: receiver.username)
        } catch {
            
        }
    }
    
    private func setTextInput(_ input: String) {
        state.textInput = input
    }
    
    private func search() {
        searchTask?.cancel()
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.3))
                let results = try await readUsersFromQueryUseCase.execute(query: state.textInput)
                state.searchResults = results.filter({ $0.username != state.sender })
            } catch {
                
            }
        }
    }
}
