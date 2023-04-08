//
//  ProfilePhotoView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 02.04.2023.
//

import SwiftUI
import SwiftUIX

struct PhotoURLLoadingView: View {
    let imageURL: URL
    let width: CGFloat
    let height: CGFloat
    @State private var isLoadingImage = true
    
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                .clipShape(Circle())
        } placeholder: {
            ActivityIndicator()
                .animated(true)
                .style(.regular)
                .frame(width: width, height: height)
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                .clipShape(Circle())
        }
        .redacted(reason: isLoadingImage ? .placeholder : [])
        .onAppear {
            isLoadingImage = false
        }
    }
}
