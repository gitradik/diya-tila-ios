//
//  MainView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        VStack {
            if sessionStore.isLoading {
                LoaderView()
            } else {
                if sessionStore.isLoggedIn {
                    VStack {
                        ProfileView(sessionStore: sessionStore)
                        Spacer()
                        LogoutView(sessionStore: sessionStore)
                    }
                    .overlay(
                        NotificationView()
                            .frame(maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
                    )
                } else {
                    AuthView(sessionStore: sessionStore)
                }
            }
        }
    }
}
