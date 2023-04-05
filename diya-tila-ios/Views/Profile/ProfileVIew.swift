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
                ProfilePhotoURLLoading(imageURL: user.photoURL)
                
                Divider().scenePadding(.top)
                
                if let fullName = user.fullName {
                    Text(fullName)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                }
                
                if let uniqueUsername = user.userDetails?.uniqueUsername {
                    Text("@" + uniqueUsername)
                        .font(.title3)
                        .fontWeight(.light)
                }
                
                Spacer()
            }
        }.scenePadding(.top)
    }
}
