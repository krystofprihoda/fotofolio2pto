//
//  FilterView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import SwiftUI

struct FilterView: View {
    
    @ObservedObject private var viewModel: FilterViewModel
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: Constants.Dimens.spaceNone) {
            ZStack {
                Text(L.Feed.filterPortfolios)
                    .fontWeight(.medium)
                
                HStack {
                    Spacer()
                    Button(action: { viewModel.onIntent(.dismiss) }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: Constants.Dimens.spaceLarge)
                            .foregroundColor(.red).brightness(0.2)
                    }
                    .padding()
                }
            }
            .padding(Constants.Dimens.spaceMedium)
            
            /// Input
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray).opacity(0.1)
                    
                    TextField(
                        L.Feed.weddingExample,
                        text: Binding(
                            get: { viewModel.state.textInput },
                            set: { viewModel.onIntent(.registerTextInput($0)) }
                        )
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(Constants.Dimens.spaceMedium)
                 }
                .frame(height: 40)
                .cornerRadius(Constants.Dimens.radiusXSmall)
                .padding(.leading)
                
                Button(
                    action: { viewModel.onIntent(.addTag) },
                    label: {
                        Text(L.Feed.add)
                            .padding(Constants.Dimens.spaceMedium)
                            .frame(height: 40)
                            .background(.red).brightness(0.5)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Dimens.radiusXSmall)
                    }
                )
                .padding(.trailing)
            }
            .padding(.bottom)
            
            /// Tags
            HStack {
                VStack(alignment: .leading) {
                    ForEach(viewModel.state.tags, id: \.self) { tag in
                        HStack {
                            Text(tag)
                                .padding([.leading, .trailing], 9)
                                .padding([.bottom, .top], 7)
                                .background(.red).brightness(0.5)
                                .foregroundColor(.white)
                                .cornerRadius(Constants.Dimens.radiusXSmall)
                            
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
                .padding(.leading)
                
                Spacer()
            }
            
            Spacer()
        }
        .background(
            .gray
            .opacity(0.15)
        )
    }
}
#Preview {
    FilterView(viewModel: .init(flowController: nil))
}
