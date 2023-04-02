//
//  LogoutView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct LogoutView: View {
    let sessionStore: SessionStore
    
    
    var body: some View {
        Button("Log out") {
            sessionStore.signOut()
        }
    }
}
