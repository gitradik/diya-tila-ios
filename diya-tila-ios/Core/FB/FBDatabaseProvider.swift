//
//  File.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import Firebase
import FirebaseDatabase

class FBDatabaseProvider: ObservableObject {
    
    let environment = EnvironmentFile.shared
    
    let db: Database
    
    init() {
        guard let url = environment.plistDictionary?["DATABASE_URL"] as? String else {
            fatalError("Wrong environment variable value: \"DATABASE_URL\"")
        }
        db = Database.database(url: url)
    }
    
    enum FBDatabaseUpdates {
        case Usernames(String)
        case UserDetails(String, String)

        func call() -> [String: Any] {
            switch self {
            case .Usernames(let username):
                let key = "Usernames/\(username)"
                return [key: username]
            case .UserDetails(let userID, let uniqueUsername):
                let key = "UsersDetails/\(userID)"
                let value: [String: Any] = ["uniqueUsername": uniqueUsername]
                return [key: value]
            }
        }
    }
}
