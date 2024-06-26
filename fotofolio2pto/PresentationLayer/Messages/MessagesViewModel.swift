//
//  MessagesViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI
import Resolver

final class MessagesViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    // MARK: Dependencies
    
    @LazyInjected private var getChatsForUserUseCase: GetChatsForUserUseCase
    @LazyInjected private var getUserDataFromUsernameUseCase: GetUserDataFromUsernameUseCase
    
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
        
        executeTask(Task { await fetchChats() })
    }
    
    // MARK: State
    
    struct State {
        var isLoading: Bool = true
        var chats: [Chat] = []
        var sender = ""
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case showChat(Chat)
        case showNewChat
        case refreshChats
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .showChat(let chat): showChat(chat)
            case .showNewChat: showNewChat()
            case .refreshChats: await fetchChats()
            }
        })
    }
    
    // MARK: Additional methods
    
    private func fetchChats() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        guard !state.sender.isEmpty else { return }
        
        do {
            state.chats = try await getChatsForUserUseCase.execute(user: state.sender)
        } catch {
            
        }
    }
    
    private func showChat(_ chat: Chat) {
        guard let receiver = chat.getReceiver(sender: state.sender) else { return }
        flowController?.showChat(sender: state.sender, receiver: receiver)
    }
    
    private func showNewChat() {
        flowController?.showNewChat()
    }
    
    public func getReceiverProfilePicture(chat: Chat) -> IImage? {
        return chat.chatOwners.first(where: { state.sender != $0.username })?.profilePicture
    }
}
