//
//  ContentView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var sessionStore = SessionStore(userDataProvider: UserDataProvider())
    
    var body: some View {
        MainView()
            .environmentObject(sessionStore)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
