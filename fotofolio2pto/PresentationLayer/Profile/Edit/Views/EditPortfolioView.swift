//
//  EditPortfolioView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct EditPortfolioView: View {
    
    @ObservedObject var viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ForEach(viewModel.state.portfolios) { portfolio in
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        // intent remove portfolio by id
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                .fill()
                                .foregroundColor(.red).brightness(0.42)
                                .frame(width: 45, height: 38)
                                .opacity(0.25)
                            
                            Image(systemName: "trash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.red)
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                            .foregroundColor(.gray).brightness(0.4)
                            .frame(height: 38)
                        
                        TextField(L.Profile.portraitsExample, text: Binding(get: { viewModel.state.portfolios.filter({ $0.id == portfolio.id }).description }, set: { _ in }))
                            .font(.body)
                            .frame(height: 38)
                            .foregroundColor(.gray)
                            .offset(x: 9)
                    }
                    
                    Spacer()
                }
                .padding(.top, 6)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        Button(action: {
                            // add folio
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                    .fill(Color.gray).brightness(0.34)
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: 90, height: 90)
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 17, height: 17)
                                    .foregroundColor(.black).brightness(0.3)
                            }
                        }
                        
                        ForEach(portfolio.photos, id: \.id) { img in
                            ZStack {
                                if case MyImageEnum.remote(let url) = img.src {
                                    AsyncImage(url: url) { image in
                                        ZStack {
                                            image
                                                .resizable()
                                                .aspectRatio(1.0, contentMode: .fill)
                                                .frame(width: 90, height: 90)
                                                .cornerRadius(Constants.Dimens.radiusXSmall)
                                                .blur(radius: 1.5)
                                                .clipShape(RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall))
                                            
                                            RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                                .fill(Color.gray)
                                                .aspectRatio(1.0, contentMode: .fit)
                                                .frame(width: 90, height: 90)
                                                .opacity(0.65)
                                        }
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                            .fill(Color.gray).brightness(0.25)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: 90, height: 90)
                                    }
                                } else if case MyImageEnum.local(let image) = img.src {
                                    ZStack {
                                        image
                                            .resizable()
                                            .aspectRatio(1.0, contentMode: .fill)
                                            .frame(width: 90, height: 90)
                                            .cornerRadius(Constants.Dimens.radiusXSmall)
                                            .blur(radius: 1.5)
                                            .clipShape(RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall))
                                        
                                        RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                                            .fill(Color.gray)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .frame(width: 90, height: 90)
                                            .opacity(0.65)
                                    }
                                }
                                
                                Button(action: {
                                    // remove photo from portfolio -> portfolio.id & img.id
                                }) {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 17, height: 17)
                                        .foregroundColor(.red)
                                        .opacity(0.9)
                                        .padding()
                                }
                            }
                        }
                        .transition(.opacity)
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .foregroundColor(.gray).brightness(0.42)
                        .frame(height: 85)
                        .padding(.trailing, 7)
                    
                    TextEditor(text: Binding(get: { viewModel.state.portfolios.filter({ $0.id == portfolio.id }).description }, set: { _ in }))
                        .font(.system(size: 16))
                        .frame(height: 85)
                        .lineSpacing(2)
                        .foregroundColor(.gray)
                        .padding([.leading, .top], 5)
                }
                
                if portfolio.tags.count < 5 {
                    HStack {
                        ZStack {
                            Rectangle()
                               .foregroundColor(.gray).brightness(0.37)
                            
                            TextField(L.Profile.weddingExample, text: Binding(get: { viewModel.state.portfolioTagsInput }, set: { _ in }))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                         }
                        .frame(height: 40)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                        
                        Button(action: {
                            // add tags
                        }, label: {
                            Text(L.Profile.add)
                                .padding(10)
                                .background(.red).brightness(0.5)
                                .foregroundColor(.white)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                        })
                            .padding(.trailing, 7)
                    }
                    .transition(.opacity)
                }
                
                VStack(alignment: .leading) {
                    ForEach(portfolio.tags, id: \.self) { tag in
                        HStack {
                            Text(tag)
                                .padding([.leading, .trailing], 9)
                                .padding([.bottom, .top], 7)
                                .background(.gray).brightness(0.4)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                            
                            Button(action: {
                                // remove tags from portfolio
                            }) {
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
            }
            .padding(.leading)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    EditPortfolioView(viewModel: .init(flowController: nil, userData: .dummy1, portfolios: [.dummyPortfolio2]))
}
