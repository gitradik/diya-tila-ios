//
//  File.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import Firebase
import FirebaseDatabase

class UserDataProvider: FBDatabaseProvider {
    
    func updateUserDetails(user: User, completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let id = user.id,
        let userDetails = user.userDetails
        else {
            completion(nil, nil)
            return
        }
        
        let userDetailsDictionary = userDetails.toDictionary()
        let usersDetailsUpdates = FBDatabaseUpdates.UserDetails(id, userDetailsDictionary)
        self.db.reference().updateChildValues(usersDetailsUpdates.call()) { error, ref in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(userDetailsDictionary, error)
            
            print(">>>>>>>>>>>>>>>", ref)
        }
    }
    
    func getUserDetais(user: User, completion: @escaping ([String: Any]?, Error?) -> Void) {
        if let id = user.id {
            let ref = self.db.reference(withPath: FBDatabaseTables.UserDetails.rawValue)
            ref.child(id).getData { error, snapshot in
                if let snap = snapshot {
                    completion(snap.value! as? [String: Any], nil)
                } else if let err = error {
                    completion(nil, err)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func uniqueUsernameAlreadyExist(user: User, completion: @escaping (Bool, Error?) -> Void) {
        if let id = user.id {
            let ref = self.db.reference(withPath: FBDatabaseTables.UserDetails.rawValue)
            ref.child(id).observeSingleEvent(of: .value, with: { snapshot in
                completion(snapshot.exists(), nil)
            })
        } else {
            completion(false, nil)
        }
    }
    
    func addUserUniqueName(user: User, completion: @escaping (String?, Error?) -> Void) {
        if let fullName = user.fullName {
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                generateUniqueLoginName(generateNameFromFullname(fullName)) { uniqueUsername, error in
                    // Handle the result on the main thread
                    DispatchQueue.main.async {
                        if let uniqueUsername = uniqueUsername {
                            let usernamesUpdates = FBDatabaseUpdates.Usernames(uniqueUsername)
                            self.db.reference().updateChildValues(usernamesUpdates.call())
                            
                            let usersDetailsUpdates = FBDatabaseUpdates.UserDetails(user.id!, ["uniqueUsername": uniqueUsername])
                            self.db.reference().updateChildValues(usersDetailsUpdates.call())
                            completion(uniqueUsername, error)
                        } else if error != nil {
                            completion(nil, error)
                        } else {
                            completion(nil, nil)
                        }
                    }
                }
            }
        }
    }
    
    // Define a function to generate a unique login name
    private func generateUniqueLoginName(_ loginName: String, completion: @escaping (String?, Error?) -> Void) {
        let ref = self.db.reference(withPath: FBDatabaseTables.Usernames.rawValue)
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
            completion(snapshot.exists())
        })
    }
    
    private func generateNameFromFullname(_ fullName: String) -> String {
        let components = fullName.split(separator: " ")
        
        var username = ""
        for str in components {
            username += str
        }
        
        return username.lowercased()
    }
}
