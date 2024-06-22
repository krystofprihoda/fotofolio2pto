//
//  ProfilePictureView.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 22.06.2024.
//

import SwiftUI

struct ProfilePictureView: View {
    @State var profilePicture: IImage?
    
    var width = 50.0
    
    var body: some View {
        if let pic = profilePicture {
            if case MyImageEnum.remote(let url) = pic.src {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: width)
                        .cornerRadius(100)
                } placeholder: {
                    ZStack {
                        Circle()
                            .foregroundColor(.gray).brightness(0.33)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: width)

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
            } else if case MyImageEnum.local(let img) = pic.src {
                img
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: width)
                    .cornerRadius(100)
            }
        } else {
            Circle()
                .foregroundColor(.gray).brightness(0.33)
                .frame(width: width, height: width)
        }
    }
}

#Preview {
    ProfilePictureView()
}
