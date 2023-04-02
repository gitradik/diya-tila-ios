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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image("google")
                    .resizable()
                    .frame(width: 34, height: 34)
                Text("Sign in with Google")
                    .fontWeight(.semibold)
                    .font(.body)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .cornerRadius(40)
        }.buttonStyle(.bordered)
            .tint(.cyan)
    }
}
