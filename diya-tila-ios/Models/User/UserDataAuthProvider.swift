//
//  UserDataAuthProvider.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 02.04.2023.
//

import Firebase
import FirebaseAuth
import GoogleSignIn

class UserDataAuthProvider: ObservableObject {
    
    private func printLoginError(_ error: Error) {
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
                completion(authResult?.user, nil)
            }
        }
    }
    
    func register(_ email: String, _ passwd: String, completion: @escaping (FirebaseAuth.User?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: passwd) { authResult, error in
            if let err = error {
                completion(nil, err)
                return
            }
            
            guard (authResult?.user != nil) else {
                completion(nil, nil)
                return
            }
            
            completion(authResult?.user, nil)
        }
    }
    
    func updatePhotoURL(url: URL, completion: @escaping (FirebaseAuth.User?, Error?) -> Void) {
        let user = Auth.auth().currentUser
        let changeRequest = user?.createProfileChangeRequest()
        changeRequest?.photoURL = url
        changeRequest?.commitChanges { error in
            if let err = error {
                completion(nil, err)
                return
            }
            
            completion(user, nil)
        }
    }
    
    func updateDisplayName(fullName: String, completion: @escaping (FirebaseAuth.User?, Error?) -> Void) {
        let user = Auth.auth().currentUser
        let changeRequest = user?.createProfileChangeRequest()
        changeRequest?.displayName = fullName
        changeRequest?.commitChanges { error in
            if let err = error {
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
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: u.accessToken.tokenString)
                Auth.auth().signIn(with: credential) { result, error in
                    if let err = error {
                        self.printLoginError(err)
                        completion(nil, err)
                    } else {
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



// MARK: no need yet
// Function to link a provider account to the current user account
//    private func linkProviderAccount(credential: AuthCredential, completion: @escaping (Error?) -> Void) {
//        if let currentUser = Auth.auth().currentUser {
//            currentUser.link(with: credential, completion: { (result, error) in
//                if let error = error {
//                    completion(error)
//                } else {
//                    completion(nil)
//                }
//            })
//        }
//    }
//    private func unlinkProvider(providerID: String, completion: @escaping (Error?) -> Void) {
//        if let currentUser = Auth.auth().currentUser {
//            currentUser.unlink(fromProvider: providerID) { (result, error) in
//                if let error = error {
//                    // Handle unlinking error
//                    completion(error)
//                } else {
//                    // Account successfully unlinked
//                    completion(nil)
//                }
//            }
//        }
//    }
