//
//  ProfileVIew.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct ProfileView: View {
    let sessionStore: SessionStore
    
    @State private var count = 0
    
    @State private var showSignup = false
    @State private var showAccountList = false
    @State private var form = Form(fields: [
        FormField(type: .text, defaultValue: "", label: "Full Name", placeholder: "", validationRules: [.required]),
        FormField(type: .number, defaultValue: "", label: "Phone", placeholder: "", validationRules: [.required]),
    ])
    
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
//                    NotificationStore.shared.showNotification(title: "Hello Guy", message: "Dada jkhsdjk h sadh aj", duration: 10)
                    self.showSignup.toggle()
                }
                
                PhotoURLLoadingView(imageURL: photoURL, width: 100, height: 100)
                Text("@\(uniqueUsername)")
                Divider()
                Spacer()
                
                VStack {
                    form.renderFields()
                }
                
                Button(action: {
                    count += 1
                    notificationStore.showNotification(title: "Заголовок уведомления " + String(count), message: "Текст уведомления", duration: Double.random(in: 3...7))
                }, label: {
                    Text("Click")
                })
                Spacer()
            }
        }
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
