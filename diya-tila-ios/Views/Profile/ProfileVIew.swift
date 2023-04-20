//
//  ProfileVIew.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct ProfileView: View {
    let sessionStore: SessionStore
    
    @State private var showSignup = false
    
    @StateObject var notificationStore = NotificationStore.shared
    
    
    var body: some View {
        VStack {
            if let user = sessionStore.session,
               let photoURL = user.photoURL,
               let userDetails = user.userDetails,
               let uniqueUsername = userDetails.uniqueUsername {
                
                ProfileAccountView(list: [user], selected: user, select: { selected in
                    print(selected)
                }) {
                    self.showSignup.toggle()
                }
                
                PhotoURLLoadingView(imageURL: photoURL, width: 100, height: 100)
                Text("@\(uniqueUsername)")
                Divider()
            }
        }.padding(.horizontal)
        .sheet(isPresented: self.$showSignup) {
            PopoverTitleAndCloseView(title: "Add account", isPresent: self.$showSignup)
            SignupView() { name, email, passwd, image in
                guard let image = image else {return}
                sessionStore.register(name: name, email: email, passwd: passwd, uiImage: image)
                self.showSignup.toggle()
            } signUpGoogle: {
                sessionStore.googleLogin()
                self.showSignup.toggle()
            }
        }
        .scenePadding(.top)
    }
}
