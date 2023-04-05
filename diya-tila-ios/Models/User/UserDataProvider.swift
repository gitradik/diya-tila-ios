//
//  File.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import Firebase
import FirebaseDatabase

class UserDataProvider: FBDatabaseProvider {
    
    func addUserUniqueName(user: User, completion: @escaping (String?, Error?) -> Void) {
        if let fullName = user.fullName {
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                generateUniqueLoginName(generateNameFromFullname(fullName)) { uniqueUsername, error in
                    // Handle the result on the main thread
                    DispatchQueue.main.async {
                        if let uniqueUsername = uniqueUsername {
                            let usernamesUpdates = FBDatabaseUpdates.Usernames(uniqueUsername)
                            self.db.reference().updateChildValues(usernamesUpdates.call())
                            
                            let usersDetailsUpdates = FBDatabaseUpdates.UserDetails(user.id!, uniqueUsername)
                            self.db.reference().updateChildValues(usersDetailsUpdates.call())
                            completion(uniqueUsername, error)
                        } else if error != nil {
                            completion(nil, error)
                        }
                    }
                }
            }
        }
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
    
    private func generateNameFromFullname(_ fullName: String) -> String {
        let components = fullName.split(separator: " ")
        let firstName = String(components.first ?? "")
        let lastName = String(components.last ?? "")
        let username = "\(firstName)\(lastName)"
        return username.lowercased()
    }
}
