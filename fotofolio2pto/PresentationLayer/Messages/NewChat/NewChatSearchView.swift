//
//  NewChatSearchView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 26.06.2024.
//

import SwiftUI

struct NewChatSearchView: View {
    
    @ObservedObject private var viewModel: NewChatSearchViewModel
    
    init(viewModel: NewChatSearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                   .foregroundColor(.gray).brightness(0.37)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Hledat", text: Binding(get: { viewModel.state.textInput }, set: { viewModel.onIntent(.setTextInput($0)) }))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: viewModel.state.textInput) { _ in
                            viewModel.onIntent(.search)
                        }
                }
                .padding()
             }
            .frame(height: 45)
            .cornerRadius(10)
            .padding([.leading, .trailing])
            
            //results
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.state.searchResults) { user in
                    Button(action: { viewModel.onIntent(.showNewChatWithUser(user)) }) {
                        HStack {
                            ProfilePictureView(profilePicture: user.profilePicture)
                                .padding(.leading, 20)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(user.username)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black).brightness(0.2)
                                    .padding(.bottom, 4)
                                
                                Text(user.location)
                                    .font(.system(size: 13))
                                    .foregroundColor(.black).brightness(0.3)
                                    .padding(.bottom, 2)
                            }
                            .padding(.leading, 7)
                            
                            Spacer()
                        }
                        .padding(.top, 12)
                        .transition(.move(edge: .trailing))
                    }
                }
            }
        }
        .padding(.top)
        .setupNavBarAndTitle("Nový chat")
        .toolbar {
//            if searchViewModel.searching {
//                Button("Zrušit") {
//                    searchViewModel.searchString = ""
//                    searchViewModel.searching = false
//                    
//                    UIApplication.shared.dismissKeyboard()
//                }
//                .transition(.opacity)
//            }
        }
//        .onChange(of: searchViewModel.searchString, perform: { _ in
//            withAnimation {
//                searchViewModel.searchedUsers = searchViewModel.fetchUsersBySubstring(input: searchViewModel.searchString, mode: searchViewModel.searchMode)
//            }
//        })
//        .gesture(DragGesture()
//                    .onChanged({ _ in
//            UIApplication.shared.dismissKeyboard()
//            
//            withAnimation {
//                searchViewModel.searching = false
//            }
//        })
//        )
    }
}

#Preview {
    NewChatSearchView(viewModel: .init(flowController: nil, sender: ""))
}
