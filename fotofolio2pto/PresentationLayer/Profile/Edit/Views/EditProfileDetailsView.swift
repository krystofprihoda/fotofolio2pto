//
//  EditProfileDetailsView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 27.06.2024.
//

import SwiftUI

struct EditProfileDetailsView: View {
    
    @ObservedObject var viewModel: EditProfileViewModel
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(L.Profile.yearsOfExperience)
                    .font(.system(size: 16))
                    .foregroundColor(.black).brightness(0.25)
                    .padding(.top, 5)
                    .padding(.bottom, 8)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .foregroundColor(.gray).brightness(0.42)
                        .frame(width: 50, height: 40)
                        
                    TextField(
                        L.Profile.yearsOfExperiencePrefill,
                        text: Binding(
                            get: { String(viewModel.state.userData!.creator!.yearsOfExperience) },
                            set: { _ in }
                        )
                    )
                        .offset(x: 17)
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .keyboardType(.decimalPad)
                }
                
                Spacer()
            }
            .padding(.leading, 20)
            
            VStack {
                HStack {
                    Text(L.Profile.description)
                        .font(.system(size: 16))
                        .foregroundColor(.black).brightness(0.25)
                    
                    Spacer()
                }
                .padding(.bottom, -7)
                .padding(.leading, 20)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                        .foregroundColor(.gray).brightness(0.42)
                        .frame(height: 85)
                        .padding(.trailing, 7)
                        
                    TextEditor(text: Binding(get: { String(viewModel.state.userData!.creator!.profileText) }, set: { _ in }))
                        .lineSpacing(1)
                        .frame(width: 340, height: 85)
                        .font(.system(size: 16))
                        .padding(.top, 6)
                        .foregroundColor(.gray)
                        .offset(x: 7)
                }
                .padding(.leading, 16)
                
                Spacer()
            }
            
            Divider()
                .padding(.bottom, 2)
                .padding(.top, 5)
                .padding([.leading, .trailing], 7)
        }
    }
}

#Preview {
    EditProfileDetailsView(viewModel: .init(flowController: nil, userData: .dummy1, portfolios: [.dummyPortfolio1]))
}
