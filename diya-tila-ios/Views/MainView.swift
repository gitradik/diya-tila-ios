//
//  MainView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import Foundation
import SwiftUI

struct MainView: View {
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        VStack {
            if sessionStore.isLoading {
                ProgressView("Loading...")
            } else {
                if let user = sessionStore.session, sessionStore.isLoggedIn {
                    Text("Name: " + (user.fullName ?? ""))
                    LogoutView(sessionStore: sessionStore)
                } else {
                    AuthView(sessionStore: sessionStore)
                }
            }
        }
    }
}
