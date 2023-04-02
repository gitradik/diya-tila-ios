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
                
                Spacer()
            }
            
            
//            InfoView(icon: "envelope", label: "Email", value: "john.doe@gmail.com")
//            InfoView(icon: "phone", label: "Phone", value: "(123) 456-7890")
//            InfoView(icon: "house", label: "Address", value: "123 Main Street, Anytown, USA")
            
//            Spacer()
        }.scenePadding(.top)
    }
}
