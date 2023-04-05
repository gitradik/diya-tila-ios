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
    private let userDataAuthProvider: UserDataAuthProvider
    private let fbSrotageDataProvider: FBStorageDataProvider
    private var listener: AuthStateDidChangeListenerHandle?
    
    init(userDataProvider: UserDataProvider,
         userDataAuthProvider: UserDataAuthProvider,
         fbSrotageDataProvider: FBStorageDataProvider) {
        self.userDataProvider = userDataProvider
        self.userDataAuthProvider = userDataAuthProvider
        self.fbSrotageDataProvider = fbSrotageDataProvider
        
        listener = Auth.auth().addStateDidChangeListener { (auth, resultFbUser) in
            guard let fbUser = resultFbUser else {
                self.session = nil
                return
            }
            
            let newUser = User(firebaseUser: fbUser)
            userDataProvider.getUserDetais(user: newUser) { resultUserDetails, error in
                let updatedUser = User(
                    from: combineTwoDictionaries(
                        dict1: newUser.toDictionary(),
                        dict2: ["userDetails": resultUserDetails as Any]
                    )
                )
                self.session = updatedUser
            }
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
        userDataAuthProvider.signInWithGoogle { resultFbUser, error in
            guard let fbUser = resultFbUser else {
                self.isLoading = false
                return
            }
            
            let newUser = User(firebaseUser: fbUser)
            self.userDataProvider.uniqueUsernameAlreadyExist(user: newUser) { result, error in
                guard error == nil, result! == false else {
                    self.isLoading = false
                    return
                }

                self.addUserUniqueName(user: newUser) { result, error in
                    self.isLoading = false
                }
            }
        }
    }
    
    func register(name: String, email: String, passwd: String, uiImage: UIImage) {
        self.isLoading = true
        let imageName = uiImage.accessibilityLabel ?? "Unknown"
        let imagePath = "profile_images/\(imageName).jpg"
        
        fbSrotageDataProvider.uploadImage(uiImage, path: imagePath) { result in
            switch result {
            case .success(let url):
                self.userDataAuthProvider.register(email, passwd) { registerResultFbUser, error in
                    guard let fbUser = registerResultFbUser else {
                        self.isLoading = false
                        return
                    }
                    
                    var newUser = User(firebaseUser: fbUser)
                    self.userDataAuthProvider.updatePhotoURL(url: URL(string: url)!) { updateResultFbUser, error in
                        newUser.photoURL = updateResultFbUser?.photoURL
                        self.userDataAuthProvider.updateDisplayName(fullName: name) { updateResultFbUser, error in
                            newUser.fullName = updateResultFbUser?.displayName
                            
                            self.addUserUniqueName(user: newUser) { result, error in
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
    
    private func addUserUniqueName(user: User, completion: @escaping (Bool?, Error?) -> Void) {
        self.userDataProvider.addUserUniqueName(user: user) { result, error in
            guard error == nil else {
                completion(true, error)
                return
            }
            
            let userDictionary = user.toDictionary()
            let updatedUser = User(
                from: combineTwoDictionaries(
                    dict1: userDictionary,
                    dict2: ["userDetails": ["uniqueUsername": result]]
                )
            )
            self.session = updatedUser
            completion(true, nil)
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
