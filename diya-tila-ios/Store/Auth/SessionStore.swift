//
//  SessionStore.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import FirebaseAuth
import GoogleSignIn

class SessionStore : ObservableObject {
    @Published var session: User?
    @Published var isLoading = false
    var isLoggedIn: Bool { session != nil }
    
    private let userDataProvider: UserDataProvider
    private var listener: AuthStateDidChangeListenerHandle?
    
    init(userDataProvider: UserDataProvider) {
        self.userDataProvider = userDataProvider
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(firebaseUser: user)
            } else {
                self.session = nil
            }
        }
    }
    
    func login(email: String, passwd: String) {
        self.isLoading = true
        userDataProvider.signIn(email, passwd) { result, error in
            self.isLoading = false
        }
    }
    
    func googleLogin() {
        self.isLoading = true
        userDataProvider.signInWithGoogle { result, error in
            self.isLoading = false
        }
    }
    
    func register(name: String, email: String, passwd: String) {
        self.isLoading = true
        userDataProvider.register(name, email, passwd) { registerResult, error in
            if registerResult != nil {
                self.userDataProvider.update(fullName: name) { updateResult, error in
                    self.session?.fullName = updateResult?.displayName
                    self.isLoading = false
                }
            } else {
                self.isLoading = false
            }
        }
    }
    
    func signOut() {
        userDataProvider.signOut()
    }
    
    deinit {
        if let l = listener {
            Auth.auth().removeStateDidChangeListener(l)
        }
    }
}
