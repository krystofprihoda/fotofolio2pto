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

    @LazyInjected private var getChatUseCase: GetChatUseCase
    @LazyInjected private var sendMessageUseCase: SendMessageUseCase
    @LazyInjected private var getLatestChatMessagesUseCase: GetLatestChatMessagesUseCase

    private weak var flowController: MessagesFlowController?
    
    // MARK: Init

    init(
        flowController: MessagesFlowController?,
        sender: String,
        receiver: String
    ) {
        self.flowController = flowController
        super.init()
        state.sender = sender
        state.receiver = receiver
    }

    // MARK: Lifecycle

    override func onAppear() {
        super.onAppear()
        
        if state.chat == nil {
            executeTask(Task { await fetchChat() })
        }
        
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
        var chat: Chat? = nil
        var sender = ""
        var receiver = ""
        var textInput = ""
    }

    @Published private(set) var state = State()

    // MARK: Intent

    enum Intent {
        case setTextInput(String)
        case sendMessage
        case goBack
    }

    @discardableResult
    func onIntent(_ intent: Intent) -> Task<Void, Never> {
        executeTask(Task {
            switch intent {
            case .setTextInput(let input): setTextInput(input)
            case .sendMessage: await sendMessage()
            case .goBack: dismissView()
            }
        })
    }

    // MARK: Additional methods
    
    private func fetchChat() async {
        state.isLoading = true
        defer { state.isLoading = false }
        
        do {
            state.chat = try await getChatUseCase.execute(sender: state.sender, receiver: state.receiver)
        } catch {
            // Log
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
        guard let chat = state.chat else { return }
        
        do {
            let newMessages = try await getLatestChatMessagesUseCase.execute(for: chat)
            await MainActor.run {
                state.chat?.messages = newMessages
            }
        } catch {
            // Log
        }
    }
    
    private func setTextInput(_ input: String) {
        state.textInput = input
    }
    
    private func sendMessage() async {
        do {
            guard let chat = state.chat else { return }
            try await sendMessageUseCase.execute(text: state.textInput, chat: chat, sender: state.sender)
            let newMessages = try await getLatestChatMessagesUseCase.execute(for: chat)
            
            state.chat?.messages = newMessages
            state.textInput = ""
        } catch {
            // Log
        }
    }
    
    private func dismissView() {
        flowController?.navigationController.popViewController(animated: true)
    }
}
