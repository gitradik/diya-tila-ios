//
//  ProfileVIew.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct ProfileView: View {
    let sessionStore: SessionStore
    let fbDataBaseProvider: FirebaseDataBaseProvider
    
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
                
                Spacer()
            }
        }.scenePadding(.top)
            .onAppear {
                // MARK: need take to some other place which start User register 
//                if let user = sessionStore.session,
//                   let id = sessionStore.session?.id {
//                    fbDataBaseProvider.addUserUniqueName(
//                        currentUserID: id,
//                        user: user
//                    )
//                }
            }
    }
}
