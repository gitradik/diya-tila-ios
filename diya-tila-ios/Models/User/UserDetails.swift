//
//  UserDetail.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 04.04.2023.
//

import FirebaseAuth

struct UserDetails {
    var uniqueUsername: String?
    
    init(from dict: [String: Any]) {
        self.uniqueUsername = (dict["userDetails"] as? [String: Any])!["uniqueUsername"] as? String ?? nil
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uniqueUsername": uniqueUsername as Any,
        ]
    }
}

