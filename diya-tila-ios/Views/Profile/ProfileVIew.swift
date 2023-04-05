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
            if let user = sessionStore.session {
                if let fullName = user.fullName {
                    DropdownView()
                }
                
                ProfilePhotoURLLoadingView(imageURL: user.photoURL).padding(.bottom)
                if let uniqueUsername = user.userDetails?.uniqueUsername {
                    Text("@" + uniqueUsername)
                        .font(.title3)
                        .fontWeight(.light)
                }
                
                Divider().scenePadding(.top)
                Spacer()
            }
        }.scenePadding(.top)
    }
}
