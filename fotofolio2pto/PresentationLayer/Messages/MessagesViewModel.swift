//
//  MessagesViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI

final class MessagesViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    @AppStorage("username") var username: String = "ad.fotograf"
    
    // MARK: Dependencies
    
    // UCs
    
    private weak var flowController: MessagesFlowController?
    
    // MARK: Init
    
    init(
        flowController: MessagesFlowController?
    ) {
        self.flowController = flowController
        super.init()
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        fetchChats(for: username)
    }
    
    // MARK: State
    
    struct State {
        var isLoading: Bool = false
        var chats: [Chat] = []
        @AppStorage("username") var username: String = "ad.fotograf"
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
//        case doSomething(sth: Int)
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
//            case .doSomething(let sth): doSomething(sth)
            }
        })
    }
    
    // MARK: Additional methods
    
    private func fetchChats(for: String) {
        state.chats = [.dummy1]
    }
}
