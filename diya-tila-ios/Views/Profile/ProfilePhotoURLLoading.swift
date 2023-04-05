//
//  ProfilePhotoView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 02.04.2023.
//

import SwiftUI
// #4cfeb1
struct ProfilePhotoURLLoadingView: View {
    let imageURL: URL!
    @State private var isLoadingImage = true
    
    var body: some View {
        VStack {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .clipShape(Circle())
                    .shadow(radius: 4)
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .clipShape(Circle())
            }
            .redacted(reason: isLoadingImage ? .placeholder : [])
            .onAppear {
                isLoadingImage = false
            }
        }
    }
}
