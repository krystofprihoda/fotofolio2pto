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
                                        .font(.callout)
                                        .multilineTextAlignment(.leading)
                                        .padding(Constants.Dimens.spaceSemiMedium)
                                        .background(isSender ? .mainAccent : .gray)
                                        .cornerRadius(Constants.Dimens.radiusXSmall)
                                        .foregroundStyle(.white)

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
            
            ZStack(alignment: .trailing) {
                TextField(L.Onboarding.username, text: Binding(get: { viewModel.state.textInput }, set: { viewModel.onIntent(.setTextInput($0)) }))
                    .font(.body)
                    .frame(height: Constants.Dimens.textFieldHeight)
                    .padding()
                    .background(.textFieldBackground)
                    .cornerRadius(Constants.Dimens.radiusXSmall)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button(action: { viewModel.onIntent(.sendMessage) }, label: {
                    Text(L.Messages.send)
                        .padding(Constants.Dimens.textFieldButtonSpace)
                        .background(.mainAccent)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        .foregroundColor(.white)
                        .disabledOverlay(viewModel.state.textInput.isEmpty)
                        .padding(.trailing, Constants.Dimens.spaceXSmall)
                })
            }
        }
        .padding()
        .setupNavBarAndTitle(viewModel.state.receiver)
        .lifecycle(viewModel)
    }
}

#Preview {
    ChatView(viewModel: .init(flowController: nil, sender: "", receiver: ""))
}
