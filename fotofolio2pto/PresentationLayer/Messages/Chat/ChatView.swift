//
//  ChatView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject private var viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if viewModel.state.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding(.top, Constants.Dimens.spaceXXLarge)
                    } else {
                        if let messages = viewModel.state.chat?.messages {
                            ForEach(messages) { message in
                                HStack {
                                    let isSender = message.from == viewModel.state.sender
                                    
                                    if isSender { Spacer() }
                                    
                                    Text(message.body)
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.leading)
                                        .padding(15)
                                        .background(isSender ? .red.opacity(0.13) : .gray.opacity(0.2))
                                        .cornerRadius(9)

                                    if !isSender { Spacer() }
                                }
                            }
                        } else {
                            Text(L.Messages.noMessages)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            HStack {
                ZStack {
                    Rectangle()
                       .foregroundColor(.gray).brightness(0.37)
                    
                    TextField(L.Messages.prefill, text: Binding(get: { viewModel.state.textInput }, set: { viewModel.onIntent(.setTextInput($0)) }))
                        .autocapitalization(.none)
                        .padding()
                 }
                .frame(height: 45)
                .cornerRadius(10)
                
                Button(action: { viewModel.onIntent(.sendMessage) }, label: {
                    Text(L.Messages.send)
                        .padding([.top, .bottom], 11)
                        .padding([.leading, .trailing], 7)
                        .background(.red).brightness(0.35)
                        .foregroundColor(.white)
                        .cornerRadius(9)
                })
            }
        }
        .padding()
        .setupNavBarAndTitle(L.Messages.chatTitle)
        .lifecycle(viewModel)
    }
}

#Preview {
    ChatView(viewModel: .init(flowController: nil, sender: "", receiver: ""))
}
