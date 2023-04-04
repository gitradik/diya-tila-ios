//
//  UserModel.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import FirebaseAuth

struct User {
    var id: String?
    var fullName: String?
    var email: String!
    var photoURL: URL?
    
    init(firebaseUser: FirebaseAuth.User)  {
        self.id = firebaseUser.uid
        self.fullName = firebaseUser.displayName
        self.email = firebaseUser.email
        self.photoURL = firebaseUser.photoURL
    }
    
    init(from dict: [String: Any]) {
        self.id = dict["uid"] as? String ?? nil
        self.fullName = dict["displayName"] as? String ?? nil
        self.email = dict["email"] as? String
        self.photoURL = dict["photoURL"] as? URL ?? nil
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id as Any,
            "fullName": fullName as Any,
            "email": email as Any,
            "photoURL": photoURL as Any,
        ]
    }
}
