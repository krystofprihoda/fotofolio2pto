//
//  RegisterView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 04.03.2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject private var viewModel: RegisterViewModel
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        RegisterWrapperView {
            VStack {
                TextField("Jméno", text: Binding(get: { viewModel.state.name }, set: { viewModel.onIntent(.onNameChanged($0)) }))
                    .font(.system(size: 18))
                    .frame(height: Constants.Dimens.textFieldHeight)
                    .padding()
                    .background(.textFieldBackground)
                    .cornerRadius(10)
                    .disableAutocorrection(true)
                
                TextField("Email", text: Binding(get: { viewModel.state.email }, set: { viewModel.onIntent(.onEmailInput($0)) }))
                    .font(.system(size: 18))
                    .frame(height: Constants.Dimens.textFieldHeight)
                    .padding()
                    .background(.textFieldBackground)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: viewModel.state.email) { _ in
                        viewModel.onIntent(.onEmailChanged)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.mainAccent, lineWidth: 1)
                            .opacity(viewModel.state.showInvalidEmailFormat ? 1 : 0)
                    )
                
                if viewModel.state.showInvalidEmailFormat {
                    Text("Neplatný formát emailové adresy!")
                        .font(.system(size: 14))
                        .foregroundColor(.mainAccent)
                }
                
                Button(action: {}, label: {
                    Text("Další")
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.mainAccent)
                        .cornerRadius(10)
                })
                .disabled(!viewModel.state.emailVerified)
            }
            .animation(.default, value: viewModel.state.showInvalidEmailFormat)
        }
    }
}

struct RegisterWrapperView<Content: View>: View {
    
    private let content: Content
    
    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray
            
            VStack(alignment: .leading, spacing: Constants.Dimens.spaceNone) {
                Text("Registrace.")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                    .padding(.leading)
                    .padding(.leading)
                
                VStack {
                    content
                        .padding()
                }
                .background(.white)
                .cornerRadius(10)
                .padding()
            }
        }
        .ignoresSafeArea(.all)
    }
}
