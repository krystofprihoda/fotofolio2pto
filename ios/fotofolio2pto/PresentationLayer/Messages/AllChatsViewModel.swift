//
//  AllChatsViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import Foundation
import SwiftUI
import Resolver

final class AllChatsViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties
    
    private var chatUpdateTimer: Timer?
    
    // MARK: Dependencies
    
    @LazyInjected private var readChatsUseCase: ReadChatsUseCase
    @LazyInjected private var readUserByIdUseCase: ReadUserByIdUseCase
    @LazyInjected private var updateChatReadUseCase: UpdateChatReadUseCase
    
    private weak var flowController: MessagesFlowController?
    
    // MARK: Init
    
    init(
        flowController: MessagesFlowController?,
        senderId: String
    ) {
        self.flowController = flowController
        super.init()
        state.senderId = senderId
        
        executeTask(Task { await updateChats() })
    }
    
    // MARK: Lifecycle
    
    override func onAppear() {
        super.onAppear()
        
        executeTask(Task { await updateChats() })
        
        // Update every 5 seconds
         startFetchingChats()
    }
    
    override func onDisappear() {
        super.onDisappear()
        chatUpdateTimer?.invalidate()
    }
    
    // MARK: State
    
    struct State: Equatable {
        var isLoading: Bool = false
        var toastData: ToastData? = nil
        var senderId = ""
        var chats: [Chat] = []
        var receivers: [String: String] = [:]
        var unreadChatsCount = 0
    }
    
    @Published private(set) var state = State()
    
    // MARK: Intent
    
    enum Intent {
        case showChat(Chat)
        case showNewChat
        case refreshChats
        case setToastData(ToastData?)
    }
    
    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .showChat(let chat): await showChat(chat)
            case .showNewChat: showNewChat()
            case .refreshChats: await updateChats()
            case .setToastData(let toast): setToastData(toast)
            }
        })
    }
    
    // MARK: Additional methods
    
    private func setToastData(_ toast: ToastData?) {
        state.toastData = toast
    }
    
    private func startFetchingChats() {
        chatUpdateTimer?.invalidate() // Prevent multiple timers
        chatUpdateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task {
                await self?.updateChats()
            }
        }
    }
    
    private func updateChats() async {
        do {
            state.chats = try await readChatsUseCase.execute()
            
            for chat in state.chats {
                guard let receiverId = chat.chatOwnerIds.first(where: { ownerId in ownerId != state.senderId }) else {
                    let receiverData = try await readUserByIdUseCase.execute(id: state.senderId)
                    state.receivers[state.senderId] = receiverData.username
                    continue
                }
                
                let receiverData = try await readUserByIdUseCase.execute(id: receiverId)
                state.receivers[receiverId] = receiverData.username
            }
        } catch {
            state.toastData = .init(message: L.Messages.loadFailed, type: .error)
        }
        
        updateNumberOfReadChats()
    }
    
    private func updateNumberOfReadChats() {
        var count = 0
        for chat in state.chats {
            if !chat.readByIds.contains(where: { $0 == state.senderId }) {
                count += 1
            }
        }
        
        guard count > 0 else { return }
        
        state.unreadChatsCount = count
        flowController?.tabBadgeFlowDelegate?.updateCount(of: .messages, to: count, animated: true)
    }
    
    private func showChat(_ chat: Chat) async {
        guard let receiverId = chat.getReceiverId(senderId: state.senderId) else { return }
        
        if !chat.id.isEmpty {
            do {
                try await updateChatReadUseCase.execute(chatId: chat.id)
            } catch {
                state.toastData = .init(message: L.General.somethingWentWrong, type: .error)
            }
        }
        
        state.unreadChatsCount -= 1
        flowController?.tabBadgeFlowDelegate?.updateCount(of: .messages, to: state.unreadChatsCount, animated: false)
        
        flowController?.showChat(senderId: state.senderId, receiverId: receiverId)
    }
    
    private func showNewChat() {
        flowController?.showNewChat()
    }
}
