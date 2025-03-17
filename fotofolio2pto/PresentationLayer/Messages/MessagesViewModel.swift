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
    
    private var chatUpdateTimer: Timer?
    
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
        
        executeTask(Task { await fetchChats() })
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task { await updateChats() })
        
        // Update every 2 seconds
        // startFetchingChats()
    }
    
    override func onDisappear() {
        super.onDisappear()
        chatUpdateTimer?.invalidate()
    }
    
    // MARK: State
    
    struct State: Equatable {
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
    
    private func startFetchingChats() {
        chatUpdateTimer?.invalidate() // Prevent multiple timers
        chatUpdateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task {
                await self?.updateChats()
            }
        }
    }
    
    private func updateChats() async {
        guard !state.sender.isEmpty else { return }

        do {
           let newChats = try await getChatsForUserUseCase.execute(user: state.sender)
           await MainActor.run {
               state.chats = newChats
           }
        } catch {
            #warning("TODO: Log error")
        }
    }
    
    private func fetchChats() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        guard !state.sender.isEmpty else { return }
        
        do {
            state.chats = try await getChatsForUserUseCase.execute(user: state.sender)
        } catch {
            #warning("TODO: Log error")
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
