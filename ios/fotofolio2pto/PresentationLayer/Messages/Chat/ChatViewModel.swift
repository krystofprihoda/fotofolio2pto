//
//  ChatViewModel.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import Foundation
import Resolver
import SwiftUI

final class ChatViewModel: BaseViewModel, ViewModel, ObservableObject {
    // MARK: Stored properties

    private var chatUpdateTimer: Timer?
    
    // MARK: Dependencies

    @LazyInjected private var readChatUseCase: ReadChatUseCase
    @LazyInjected private var readUserByIdUseCase: ReadUserByIdUseCase
    @LazyInjected private var sendMessageUseCase: SendMessageUseCase
    @LazyInjected private var readMessagesFromChatUseCase: ReadMessagesFromChatUseCase

    private weak var flowController: MessagesFlowController?
    
    // MARK: Init

    init(
        flowController: MessagesFlowController?,
        senderId: String,
        receiverId: String
    ) {
        self.flowController = flowController
        super.init()
        state.senderId = senderId
        state.receiverId = receiverId
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
        executeTask(Task { await fetchReceiverAndChatData() })
        
        // Fetch messages every second
        // startFetchingNewMessages()
    }
    
    override func onDisappear() {
        super.onDisappear()
        chatUpdateTimer?.invalidate()
    }

    // MARK: State

    struct State {
        var isLoading: Bool = false
        var isSendingMessage: Bool = false
        var senderId = ""
        var receiverId = ""
        var receiverData: User? = nil
        var chat: Chat = .empty
        var messages: [Message] = []
        var textInput = ""
        var toastData: ToastData? = nil
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case setTextInput(String)
        case sendMessage
        case setToastData(ToastData?)
        case goBack
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .setTextInput(let input): setTextInput(input)
            case .sendMessage: await sendMessage()
            case .setToastData(let toast): setToastData(toast)
            case .goBack: dismissView()
            }
        })
    }

    // MARK: Additional methods
    
    private func fetchReceiverAndChatData() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            state.receiverData = try await readUserByIdUseCase.execute(id: state.receiverId)
            
            state.chat = try await readChatUseCase.execute(receiverId: state.receiverId)
            
            guard state.chat != .empty else { return }
            
            state.messages = try await readMessagesFromChatUseCase.execute(chatId: state.chat.id)
        } catch {
            state.toastData = .init(message: L.Messages.loadFailed, type: .error)
        }
    }
    
    private func startFetchingNewMessages() {
        chatUpdateTimer?.invalidate() // Ensure no duplicate timers
        chatUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task {
                await self?.fetchNewMessages()
            }
        }
    }
    
    private func fetchNewMessages() async {
        guard state.chat != .empty else { return }
        
        do {
            state.messages = try await readMessagesFromChatUseCase.execute(chatId: state.chat.id)
        } catch {
            state.toastData = .init(message: L.Messages.loadFailed, type: .error)
        }
    }
    
    private func setTextInput(_ input: String) {
        state.textInput = input
    }
    
    private func setToastData(_ toast: ToastData?) {
        state.toastData = toast
    }
    
    private func sendMessage() async {
        state.isSendingMessage = true
        defer { state.isSendingMessage = false }
        
        do {
            if state.chat == .empty {
                state.chat = try await sendMessageUseCase.execute(receiverId: state.receiverId, message: state.textInput)
            } else {
                state.chat = try await sendMessageUseCase.execute(chatId: state.chat.id, message: state.textInput)
            }
            
            state.textInput = ""
            await fetchNewMessages()
        } catch {
            state.toastData = .init(message: L.Messages.sendFailed, type: .error)
        }
    }
    
    private func dismissView() {
        flowController?.navigationController.popViewController(animated: true)
    }
}
