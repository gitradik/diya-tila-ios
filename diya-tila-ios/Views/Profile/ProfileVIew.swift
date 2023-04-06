//
//  ProfileVIew.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct ProfileView: View {
    
    let sessionStore: SessionStore
    
    var body: some View {
        VStack {
            if let user = sessionStore.session,
                let userDetails = sessionStore.session?.userDetails {
                DropdownView<User>(choices: [user, user], title: "Change account", mapItemView: { item in
                    Text("@\(item.userDetails!.uniqueUsername!)")
                }, mapTitleView: { item in
                    Text("\(item.fullName!)")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                })
                
                PhotoURLLoadingView(imageURL: user.photoURL!, width: 100, height: 100)
                Text("@\(userDetails.uniqueUsername!)")
                   
                
                Divider()
                Spacer()
            }
        }.scenePadding(.top)
    }
}
