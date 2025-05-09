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
                VStack(spacing: Constants.Dimens.spaceSmall) {
                    if viewModel.state.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .padding(.top, Constants.Dimens.spaceXXLarge)
                    } else {
                        if !viewModel.state.messages.isEmpty {
                            ForEach(viewModel.state.messages) { message in
                                HStack {
                                    let isSender = message.from == viewModel.state.senderId
                                    
                                    if isSender { Spacer() }
                                    
                                    Text(message.body)
                                        .font(.callout)
                                        .multilineTextAlignment(.leading)
                                        .padding(Constants.Dimens.spaceSemiMedium)
                                        .background(isSender ? .mainLight : .gray)
                                        .cornerRadius(Constants.Dimens.radiusXSmall)
                                        .foregroundStyle(.white)

                                    if !isSender { Spacer() }
                                }
                            }
                        } else {
                            Text(L.Messages.noMessages)
                                .foregroundColor(.mainText)
                        }
                    }
                }
                .padding(.top, Constants.Dimens.spaceLarge)
            }
            .padding(.horizontal, Constants.Dimens.spaceLarge)
            
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .fill(Color.textFieldBackground)
                
                HStack(spacing: Constants.Dimens.spaceNone) {
                    TextFieldView(title: L.Messages.prefill, text: Binding(
                        get: { viewModel.state.textInput },
                        set: { viewModel.onIntent(.setTextInput($0)) }
                    ))

                    Button(action: { viewModel.onIntent(.sendMessage) }) {
                        Text(L.Messages.send)
                            .padding(Constants.Dimens.textFieldButtonSpace)
                            .background(.mainLight)
                            .cornerRadius(Constants.Dimens.radiusXSmall)
                            .foregroundColor(viewModel.state.isSendingMessage ? .clear : .white)
                            .disabledOverlay(viewModel.state.textInput.isEmpty)
                    }
                    .overlay {
                        if viewModel.state.isSendingMessage {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
                    .padding(Constants.Dimens.spaceXSmall)
                }
            }
            .frame(height: Constants.Dimens.textFieldHeight)
            .padding(.horizontal, Constants.Dimens.spaceSmall)
        }
        .padding(.bottom, Constants.Dimens.spaceLarge)
        .toast(toastData: Binding(get: { viewModel.state.toastData }, set: { viewModel.onIntent(.setToastData($0)) }))
        .navigationBarItems(leading: backButton)
        .setupNavBarAndTitle(viewModel.state.receiverData?.username ?? "", hideBack: true)
        .lifecycle(viewModel)
    }
    
    private var backButton: some View {
        Button(action: { viewModel.onIntent(.goBack) }) {
            Text(L.General.back)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    ChatView(viewModel: .init(flowController: nil, senderId: "", receiverId: ""))
}
