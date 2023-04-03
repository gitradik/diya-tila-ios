//
//  UserModel.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import FirebaseAuth

struct User {
    var id: String!
    var fullName: String?
    var email: String!
    var photoURL: URL?
    
    init(firebaseUser: FirebaseAuth.User)  {
        self.id = firebaseUser.uid
        self.fullName = firebaseUser.displayName
        self.email = firebaseUser.email
        self.photoURL = firebaseUser.photoURL
   }
}
