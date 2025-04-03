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
                            .font(.body)
                            .foregroundColor(.gray)
                    } else {
                        VStack(spacing: Constants.Dimens.spaceNone) {
                            ForEach(viewModel.state.chats) { chat in
                                if let message = chat.messageIds.last {
                                    Button(action: {}) {
                                        HStack {
//                                            ProfilePictureView(
//                                                profilePicture: viewModel.getReceiverProfilePicture(chat: chat),
//                                                width: Constants.Dimens.frameSizeSmall * Constants.Dimens.halfMultiplier
//                                            )
                                            
                                            VStack(alignment: .leading, spacing: Constants.Dimens.spaceXXSmall) {
                                                Text("@" + (chat.getReceiver(sender: viewModel.state.senderId) ?? L.Messages.sender))
                                                    .font(.body)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.mainAccent)
                                                
                                                Text(formatMessage(fromId: "id", "Blablabla"))
                                                    .foregroundColor(.gray)
                                                    .font(.body)
                                            }
                                            .padding(.leading, Constants.Dimens.spaceSmall)
                                            
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
            .animation(.default, value: viewModel.state)
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
                .padding(.trailing, Constants.Dimens.spaceXSmall)
            }
        }
        .setupNavBarAndTitle(L.Messages.title)
    }
    
    private func formatMessage(fromId: String, _ message: String) -> String {
        return fromId == viewModel.state.senderId ? "\(L.Messages.youFormat) \"\(message)\"" : "\"\(message)\""
    }
}

#Preview {
    MessagesView(viewModel: .init(flowController: nil, senderId: ""))
}
