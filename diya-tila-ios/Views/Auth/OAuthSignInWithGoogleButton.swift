//
//  OAuthSignInWithGoogleButton.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct OAuthSignInWithGoogleButton: View {
    let buttonText: Text
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image("Google")
                    .resizable()
                    .frame(width: 34, height: 34)
                buttonText
                    .fontWeight(.semibold)
                    .font(.body)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .cornerRadius(40)
        }.buttonStyle(.bordered)
            .tint(Color.primaryColor)
    }
}
