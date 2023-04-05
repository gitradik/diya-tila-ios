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
        
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {
                self.session = nil
                return
            }
            let newUser = User(firebaseUser: user)
            userDataProvider.getUserDetais(user: newUser) { resultDictionary, error in
                let updatedUser = User(
                    from: combineTwoDictionaries(
                        dict1: newUser.toDictionary(),
                        dict2: ["userDetails": resultDictionary as Any]
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
        userDataAuthProvider.signInWithGoogle { result, error in
            guard let user = result else {
                self.isLoading = false
                return
            }
            
            let newUser = User(firebaseUser: user)
            self.userDataProvider.uniqueUsernameAlreadyExist(user: newUser) { result, error in
                guard error == nil else {
                    self.isLoading = false
                    return
                }

                if result! == true  {
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
                self.userDataAuthProvider.register(email, passwd) { registerResult, error in
                    if let registerResult = registerResult {
                        var newUser = User(firebaseUser: registerResult)
                        self.userDataAuthProvider.updatePhotoURL(url: URL(string: url)!) { updateResult, error in
                            newUser.photoURL = updateResult?.photoURL
                            self.userDataAuthProvider.updateDisplayName(fullName: name) { updateResult, error in
                                newUser.fullName = updateResult?.displayName
                                
                                self.addUserUniqueName(user: newUser) { result, error in
                                    self.isLoading = false
                                }
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
