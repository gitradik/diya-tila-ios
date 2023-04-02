//
//  AuthView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI
import Firebase
import GoogleSignInSwift

struct AuthView: View {
    let sessionStore: SessionStore
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Spacer()
                    LoginView { email, passwd in
                        sessionStore.login(email: email, passwd: passwd)
                    }.scenePadding(.bottom)
                    
                    OAuthSignInWithGoogleButton {
                        sessionStore.googleLogin()
                    }
                    Spacer()
                    NavigationLink(destination: SignupView { name, email, passwd in
                        sessionStore.register(name: name, email: email, passwd: passwd)
                    }) {
                        Text("Register")
                    }
                }
            }
            .scenePadding(.top)
            .scenePadding(.horizontal)
            .navigationBarTitle("Enter to #DiyaTila")
        }
    }
}
