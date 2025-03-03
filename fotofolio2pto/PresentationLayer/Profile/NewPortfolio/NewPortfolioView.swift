//
//  NewPortfolioView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct NewPortfolioView: View {
    
    @ObservedObject var viewModel: NewPortfolioViewModel
    
    init(viewModel: NewPortfolioViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text(L.Profile.titleName)
                    .font(.system(size: 18))
                
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .foregroundColor(.gray).brightness(0.35)
                        .frame(height: 38)
                    
                    TextField(
                        L.Profile.portraitsExample,
                        text: Binding(
                            get: { viewModel.state.name },
                            set: { input in viewModel.onIntent(.setName(input)) }
                        )
                    )
                        .font(.system(size: 18))
                        .frame(height: 38)
                        .foregroundColor(.gray)
                        .offset(x: 9)
                }
                .padding(.trailing, 15)
                
                Text(L.Profile.photography)
                    .font(.system(size: 18))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        Button(action: { viewModel.onIntent(.pickMedia) }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(Color.gray).brightness(0.34)
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: 150, height: 150)
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 17, height: 17)
                                    .foregroundColor(.black).brightness(0.3)
                            }
                        }
                        
                        if viewModel.state.media.isEmpty {
                            RoundedRectangle(cornerRadius: 9)
                                .fill(Color.gray).brightness(0.39)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 150, height: 150)
                            
                            RoundedRectangle(cornerRadius: 9)
                                .fill(Color.gray).brightness(0.41)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: 150, height: 150)
                        } else {
                            ForEach(viewModel.state.media) { media in
                                ZStack(alignment: .topTrailing) {
                                    if case MyImageEnum.local(let image) = media.src {
                                        image
                                            .resizable()
                                            .aspectRatio(1.0, contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(CGFloat(9))
                                    } else {
                                        RoundedRectangle(cornerRadius: 9)
                                            .fill(.red)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: 150, height: 150)
                                            .opacity(0.65)
                                    }
                                    
                                    Button(action: {}) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 9)
                                                .fill(.gray)
                                                .aspectRatio(1.0, contentMode: .fit)
                                                .frame(width: 40, height: 40)
                                                .opacity(0.55)
                                            
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 17, height: 17)
                                                .foregroundColor(.red)
                                                .opacity(0.9)
                                                .padding()
                                        }
                                    }
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(L.Profile.shortDescription)
                        .font(.system(size: 18))
                        .padding(.bottom, -2)
                        .padding(.top, 3)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .foregroundColor(.gray).brightness(0.35)
                            .frame(height: 85)
                        
                        TextEditor(text: Binding(get: { viewModel.state.description }, set: { viewModel.onIntent(.setDescriptionInput($0)) }))
                            .font(.system(size: 16))
                            .frame(height: 85)
                            .lineSpacing(2)
                            .foregroundColor(.gray)
                            .padding(.leading, 9)
                            .padding(.top, 7)
                            .transition(.opacity)
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                    }
                }
                .padding(.trailing, 15)
                
                Text(L.Profile.maxNumberOfTags)
                
                if viewModel.state.tags.count < 5 {
                    HStack {
                        ZStack {
                            Rectangle()
                               .foregroundColor(.gray).brightness(0.37)
                            
                            TextField(
                                L.Profile.weddingExample,
                                text: Binding(get: { viewModel.state.tagInput }, set: { viewModel.onIntent(.setTagInput($0)) })
                            )
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                         }
                        .frame(height: 40)
                        .cornerRadius(7)
                        
                        Button(action: {
                            viewModel.onIntent(.addTag)
                        }, label: {
                            Text(L.Profile.add)
                                .padding(10)
                                .background(.red).brightness(0.5)
                                .foregroundColor(.white)
                                .cornerRadius(7)
                        })
                    }
                    .padding(.trailing, 15)
                    .transition(.opacity)
                }
                
                VStack(alignment: .leading) {
                    ForEach(viewModel.state.tags, id: \.self) { tag in
                        HStack {
                            Text(tag)
                                .padding([.leading, .trailing], 9)
                                .padding([.bottom, .top], 7)
                                .background(.gray).brightness(0.4)
                                .cornerRadius(7)
                            
                            Button(action: { viewModel.onIntent(.removeTag(tag)) }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.gray).brightness(0.15)
                            }
                        }
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    viewModel.onIntent(.close)
                }) {
                    Text(L.Profile.cancel)
                }
                .foregroundColor(.gray)
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.onIntent(.createNewPortfolio)
                }) {
                    if viewModel.state.isLoading {
                        ProgressView().progressViewStyle(.circular)
                    } else {
                        Text(L.Profile.createNew)
                    }
                }
                .foregroundColor(.gray)
            }
        }
        .lifecycle(viewModel)
        .navigationBarBackButtonHidden(true)
        .setupNavBarAndTitle(L.Profile.newPortfolioTitle)
    }
}

#Preview {
    NewPortfolioView(viewModel: .init(flowController: nil, userData: .dummy1))
}
