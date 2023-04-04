//
//  File.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import Firebase
import FirebaseDatabase

class FirebaseDataBaseProvider: ObservableObject {
    
    let environment = EnvironmentFile.shared
    
    let db: Database
    
    init() {
        guard let url = environment.plistDictionary?["DATABASE_URL"] as? String else {
            fatalError("Wrong environment variable value: \"DATABASE_URL\"")
        }
        db = Database.database(url: url)
    }
    
    func addUserUniqueName(currentUserID: String, user: User) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            generateUniqueLoginName(generateNameFromFullname(user.fullName!)) { uniqueLoginName, error in
                // Handle the result on the main thread
                DispatchQueue.main.async {
                    if let uniqueLoginName = uniqueLoginName {
                        let usernamesChildUpdates = ["Usernames/\(uniqueLoginName)": uniqueLoginName]
                        self.db.reference().updateChildValues(usernamesChildUpdates)
//                        self.db.reference(withPath: "Usernames").setValue([uniqueLoginName: uniqueLoginName])
                        let usersDetailsChildUpdates = ["UsersDetails/\(currentUserID)": ["username": uniqueLoginName]]
                        self.db.reference().updateChildValues(usersDetailsChildUpdates)
//                        self.db.reference(withPath: "UsersDetails").setValue([currentUserID: ["username": uniqueLoginName]])
                    } else if error != nil {
                       print(error)
                    }
                }
            }
        }
    }
    
    private func generateNameFromFullname(_ fullName: String) -> String {
        let components = fullName.split(separator: " ")
        let firstName = String(components.first ?? "")
        let lastName = String(components.last ?? "")
        let username = "\(firstName)\(lastName)"
        return username.lowercased()
    }
    
    // Define a function to generate a unique login name
    private func generateUniqueLoginName(_ loginName: String, completion: @escaping (String?, Error?) -> Void) {
        let ref = self.db.reference(withPath: "Usernames")
        // Check if the login name is already in use
        var isFinish = false
        var count = 0
        let group = DispatchGroup()
        while !isFinish && count < 5 {
            group.enter()
            self.checkUserNameAlreadyExist(dbRef: ref, loginName: loginName) { result in
                count += 1
                if result == false {
                    // If the login name is not in use, return it as-is
                    completion(loginName, nil)
                    isFinish = true
                } else if count >= 5 {
                    // If the login name is already in use after 5 checks, append a random number to the end of the login name
                    let randomInt = Int.random(in: 0..<100)
                    let newLoginName = "\(loginName)\(randomInt)"
                    completion(newLoginName, nil)
                    isFinish = true
                }
                group.leave()
            }
            group.wait()
        }
    }

    
    private func checkUserNameAlreadyExist(dbRef: DatabaseReference, loginName: String, completion: @escaping(Bool) -> Void) {
        dbRef.child(loginName).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                completion(true)
            }
            else {
                completion(false)
            }
        })
    }

}
