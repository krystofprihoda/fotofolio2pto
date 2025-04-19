//
//  AllChatsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct AllChatsView: View {
    
    @ObservedObject private var viewModel: AllChatsViewModel
    
    init(viewModel: AllChatsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                if viewModel.state.isLoading {
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                } else {
                    if viewModel.state.chats.isEmpty {
                        Text(L.Messages.noMessages)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .font(.body)
                            .foregroundColor(.mainText)
                    } else {
                        VStack(spacing: Constants.Dimens.spaceNone) {
                            ForEach(viewModel.state.chats) { (chat: Chat) in
                                Button(action: { viewModel.onIntent(.showChat(chat))}) {
                                    HStack {
                                        ProfilePictureView(
                                            width: Constants.Dimens.frameSizeSmall * Constants.Dimens.halfMultiplier
                                        )
                                        
                                        VStack(alignment: .leading, spacing: Constants.Dimens.spaceXXSmall) {
                                            if let receiverId = chat.getReceiverId(senderId: viewModel.state.senderId),
                                               let receiver = viewModel.state.receivers[receiverId] {
                                                Text(receiver)
                                                    .font(.headline)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.main)
                                            }
                                            
                                            let read = chat.readByIds.contains(where: { $0 == viewModel.state.senderId })
                                            
                                            Text(formatMessage(fromId: chat.lastSenderId, chat.lastMessage))
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .foregroundColor(.mainLight)
                                                .font(.body)
                                                .fontWeight(read ? .regular : .semibold)
                                        }
                                        .padding(.leading, Constants.Dimens.spaceSmall)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.bottom, Constants.Dimens.spaceLarge)
                        }
                        .padding(Constants.Dimens.spaceLarge)
                    }
                }
            }
            .refreshable { viewModel.onIntent(.refreshChats) }
            .animation(.default, value: viewModel.state)
        }
        .toast(toastData: Binding(get: { viewModel.state.toastData }, set: { viewModel.onIntent(.setToastData($0)) }))
        .lifecycle(viewModel)
        .navigationBarItems(trailing: newChatButton)
        .setupNavBarAndTitle(L.Messages.title)
    }
    
    private var newChatButton: some View {
        Button(action: { viewModel.onIntent(.showNewChat) }) {
            Image(systemName: "square.and.pencil")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: Constants.Dimens.frameSizeXSmall)
                .foregroundColor(.mainText)
        }
    }
    
    private func formatMessage(fromId: String, _ message: String) -> String {
        return fromId == viewModel.state.senderId ? "\(L.Messages.youFormat) \"\(message)\"" : "\"\(message)\""
    }
}

#Preview {
    AllChatsView(viewModel: .init(flowController: nil, senderId: ""))
}
