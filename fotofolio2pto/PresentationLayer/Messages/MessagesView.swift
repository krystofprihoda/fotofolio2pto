//
//  MessagesView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 20.06.2024.
//

import SwiftUI

struct MessagesView: View {
    
    @ObservedObject private var viewModel: MessagesViewModel
    
    init(viewModel: MessagesViewModel) {
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
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    } else {
                        VStack(spacing: Constants.Dimens.spaceNone) {
                            ForEach(viewModel.state.chats) { chat in
                                if let message = chat.messages.last {
                                    Button(action: { viewModel.onIntent(.showChat(chat)) }) {
                                        HStack {
                                            ProfilePictureView(profilePicture: viewModel.getReceiverProfilePicture(chat: chat), width: 40)
                                            
                                            VStack(alignment: .leading, spacing: 3) {
                                                Text("@" + (chat.getReceiver(sender: viewModel.state.sender) ?? ""))
                                                    .font(.system(size: 17))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.red).brightness(0.1)
                                                
                                                Text(formatMessage(from: message.from, message.body))
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 14))
                                            }
                                            .padding(.leading, 10)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .padding(.bottom)
                        }
                        .padding()
                    }
                }
            }
            .refreshable { viewModel.onIntent(.refreshChats) }
        }
        .lifecycle(viewModel)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { viewModel.onIntent(.showNewChat) }) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: Constants.Dimens.frameSizeXSmall)
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 5)
            }
        }
        .setupNavBarAndTitle(L.Messages.title)
    }
    
    private func formatMessage(from: String, _ message: String) -> String {
        return from == viewModel.state.sender ? "\(L.Messages.youFormat) \"\(message)\"" : "\"\(message)\""
    }
}

#Preview {
    MessagesView(viewModel: .init(flowController: nil, sender: ""))
}
