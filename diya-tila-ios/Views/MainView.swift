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
    let fbDataBaseProvider = FirebaseDataBaseProvider()
    
    var body: some View {
        VStack {
            if sessionStore.isLoading {
                ProgressView("Loading...")
            } else {
                if sessionStore.isLoggedIn {
                    ProfileView(sessionStore: sessionStore, fbDataBaseProvider: fbDataBaseProvider)
                    LogoutView(sessionStore: sessionStore)
                } else {
                    AuthView(sessionStore: sessionStore)
                }
            }
        }
    }
}
