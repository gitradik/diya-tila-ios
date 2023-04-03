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
    
    private let userDataAuthProvider: UserDataAuthProvider
    private let userDataProvider: UserDataProvider
    private let fbSrotageDataProvider: FirebaseStorageDataProvider
    private var listener: AuthStateDidChangeListenerHandle?
    
    init(userDataAuthProvider: UserDataAuthProvider, userDataProvider: UserDataProvider, fbSrotageDataProvider: FirebaseStorageDataProvider) {
        self.userDataAuthProvider = userDataAuthProvider
        self.userDataProvider = userDataProvider
        self.fbSrotageDataProvider = fbSrotageDataProvider
        
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(firebaseUser: user)
            } else {
                self.session = nil
            }
        }
    }
    
    func update(user: User) {
        self.isLoading = true
        userDataProvider.update(user: user) { error in
            self.isLoading = false
        }
    }
    
    func login(email: String, passwd: String) {
        self.isLoading = true
        userDataAuthProvider.signIn(email, passwd) { result, error in
            self.isLoading = false
        }
    }
    
    func googleLogin() {
        self.isLoading = true
        userDataAuthProvider.signInWithGoogle { result, error in
            self.isLoading = false
        }
    }
    
    func register(name: String, email: String, passwd: String, uiImage: UIImage) {
        self.isLoading = true
        let imageName = uiImage.accessibilityLabel ?? "Unknown"
        let imagePath = "profile_images/\(imageName).jpg"
        
        fbSrotageDataProvider.uploadImage(uiImage, path: imagePath) { result in
            switch result {
            case .success(let url):
                self.userDataAuthProvider.register(email, passwd) { registerResult, error in
                    if registerResult != nil {
                        self.userDataAuthProvider.updatePhotoURL(url: URL(string: url)!) { updateResult, error in
                            self.session?.photoURL = updateResult?.photoURL
                            self.userDataAuthProvider.updateDisplayName(fullName: name) { updateResult, error in
                                self.session?.fullName = updateResult?.displayName
                                self.isLoading = false
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Error uploading image: \(error)")
                self.isLoading = false
            }
        }
    }
    
    func signOut() {
        userDataAuthProvider.signOut()
    }
    
    deinit {
        if let l = listener {
            Auth.auth().removeStateDidChangeListener(l)
        }
    }
}
