//
//  File.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import Firebase
import FirebaseAuth
import GoogleSignIn

class UserDataProvider: ObservableObject {
    
    func printLoginError(_ error: Error) {
        let err = error as NSError
        switch err.code {
        case AuthErrorCode.userNotFound.rawValue:
            print("User not found.")
        case AuthErrorCode.wrongPassword.rawValue:
            print("Incorrect password.")
        case AuthErrorCode.invalidEmail.rawValue:
            print("Invalid email.")
        default:
            print("Error: \(error)")
        }
    }
    
    func signIn(_ email: String, _ passwd: String, completion: @escaping (FirebaseAuth.User?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: passwd) { authResult, error in
            if let err = error {
                self.printLoginError(err)
                completion(nil, err)
            } else {
                print("User is signed in.")
                completion(authResult?.user, nil)
            }
        }
    }
    
    func register(_ name: String, _ email: String, _ passwd: String, completion: @escaping (FirebaseAuth.User?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: passwd) { authResult, error in
            if let err = error {
                print("Error creating user: \(err)")
                completion(nil, err)
                return
            }
            
            guard (authResult?.user != nil) else {
                print("Error creating user: User is nil")
                completion(nil, nil)
                return
            }
            
            completion(authResult?.user, nil)
        }
    }
    
    func update(fullName: String, completion: @escaping (FirebaseAuth.User?, Error?) -> Void) {
        let user = Auth.auth().currentUser
        let changeRequest = user?.createProfileChangeRequest()
        changeRequest?.displayName = fullName
        changeRequest?.commitChanges { error in
            if let err = error {
                print("Error updating user: \(err)")
                completion(nil, err)
                return
            }
            
            completion(user, nil)
        }
    }
    
    // MARK: OAuth
    
    // Google
    func signInWithGoogle(completion: @escaping (FirebaseAuth.User?, Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error  in
            guard error == nil else {
                return
            }
            
            if let u = result?.user,
               let idToken = u.idToken?.tokenString {
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: u.accessToken.tokenString)
                Auth.auth().signIn(with: credential) { result, error in
                    if let err = error {
                        self.printLoginError(err)
                        completion(nil, err)
                    } else {
                        print("User is signed in.")
                        completion(result?.user, nil)
                    }
                }
            }
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("signOut error:", error)
        }
    }
}
