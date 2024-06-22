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
                        Text("Žádné zprávy.")
                            .frame(width: geo.size.width, height: geo.size.height)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    } else {
                        VStack {
                            ForEach(viewModel.state.chats) { chat in
                                Button(action: {
                                    // ChatView(receiver: receiver)
                                }) {
                                    HStack {
                                        ProfilePictureView(profilePicture: chat.receiver.profilePicture, width: 40)
                                        
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("@" + chat.receiver.username)
                                                .font(.system(size: 17))
                                                .fontWeight(.medium)
                                                .foregroundColor(.red).brightness(0.1)
                                            
                                            if let message = chat.messages.last {
                                                Text(message.from == chat.sender.username ? "Vy: \"\(message.body)\"" : "\"\(message.body)\"")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 14))
                                            } else {
                                                Text("\"Poslední zpráva\"")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 15))
                                            }
                                        }
                                        .padding(.leading, 10)
                                        
                                        Spacer()
                                    }
                                    .padding([.top, .bottom], 10)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .lifecycle(viewModel)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    // NewChatSearchView()
                }) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 15)
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 5)
            }
        }
        .setupNavBarAndTitle("Zprávy")
    }
}

#Preview {
    MessagesView(viewModel: .init(flowController: nil))
}
