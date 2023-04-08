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
        if let details = dict["userDetails"] as? [String: Any],
            let uniqueUsername = details["uniqueUsername"] {
            self.uniqueUsername = uniqueUsername as? String
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uniqueUsername": uniqueUsername as Any,
        ]
    }
}

