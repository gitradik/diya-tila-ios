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
    
    enum FBDatabaseTables: String {
        case Usernames = "Usernames"
        case UserDetails = "UsersDetails"
    }
    
    enum FBDatabaseUpdates {
        case Usernames(String)
        case UserDetails(String, [String: Any])

        func call() -> [String: Any] {
            switch self {
            case .Usernames(let username):
                let key = "Usernames/\(username)"
                return [key: username]
            case .UserDetails(let userID, let dicProperties):
                let key = "UsersDetails/\(userID)"
                let value: [String: Any] = dicProperties
                return [key: value]
            }
        }
    }
}
