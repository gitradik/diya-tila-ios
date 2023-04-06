//
//  MainView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI
import SwiftUIX

struct MainView: View {
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        VStack {
            if sessionStore.isLoading {
                LoaderView()
            } else {
                if sessionStore.isLoggedIn {
                    ProfileView(sessionStore: sessionStore)
                    LogoutView(sessionStore: sessionStore)
                } else {
                    AuthView(sessionStore: sessionStore)
                }
            }
        }
    }
}
