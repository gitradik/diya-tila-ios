//
//  ProfileVIew.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct ProfileView: View {
    
    let sessionStore: SessionStore
    @StateObject var linkedAccountsStore = LinkedAccountsStore()
    @State private var showSignup = false
    
    var body: some View {
        VStack {
            if let user = sessionStore.session,
               let userDetails = user.userDetails {
                DropdownView<User>(choices: [user], title: "Change account", mapItemView: { item, index in
                    Text("@\(item.userDetails!.uniqueUsername!)")
                }, mapTitleView: { item in
                    Text("\(item.fullName!)")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }) { item in
                    self.showSignup = true
                }
                
                PhotoURLLoadingView(imageURL: user.photoURL!, width: 100, height: 100)
                Text("@\(userDetails.uniqueUsername!)")
                
                Divider()
                Spacer()
            }
        }
        .sheet(isPresented: self.$showSignup) {
            PopoverTitleAndCloseView(title: "Add account", isShow: self.$showSignup)
            SignupView() { name, email, passwd, image in
                guard let image = image else {return}
                sessionStore.register(name: name, email: email, passwd: passwd, uiImage: image)
                self.showSignup = false
            } signUpGoogle: {
                sessionStore.googleLogin()
                self.showSignup = false
            }
        }
        .scenePadding(.top)
    }
}
