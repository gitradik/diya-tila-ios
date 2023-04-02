//
//  File.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import Firebase
import FirebaseDatabase

class UserDataProvider: ObservableObject {
    let dataRef: DatabaseReference = DatabaseReference()
    
    func update(user: User, completion: @escaping (Error?) -> Void) {
        self.dataRef.child("users").child(user.id).setValue([
            "photoURL": user.photoURL
        ]) { error, _ in
            completion(error)
        }
    }
}
