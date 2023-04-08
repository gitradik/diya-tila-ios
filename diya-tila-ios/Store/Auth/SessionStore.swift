//
//  SessionStore.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import FirebaseAuth
import GoogleSignIn

class SessionStore: ObservableObject {
    let environment = EnvironmentFile.shared
    
    @Published var session: User?
    @Published var isLoading = true
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
        self.initStateDidChangeListener()
    }
    
    func login(email: String, passwd: String) {
        self.isLoading = true
        userDataAuthProvider.signIn(email, passwd) { result, error in
            self.isLoading = false
        }
    }
    
    func googleLogin() {
        self.removeStateDidChangeListener()
        self.isLoading = true
        
        userDataAuthProvider.signInWithGoogle { resultFbUser, error in
            guard error == nil else {
                self.isLoading = false
                return
            }
            guard let fbUser = resultFbUser else {
                self.isLoading = false
                return
            }
            
            let newUser = User(firebaseUser: fbUser)
            self.userDataProvider.uniqueUsernameAlreadyExist(user: newUser) { result, error in
                guard error == nil else {
                    self.isLoading = false
                    return
                }
                
                guard result == false else {
                    self.userDataProvider.getUserDetais(user: newUser) { resultUserDetails, error in
                        guard error == nil else {
                            self.session = nil
                            self.isLoading = false
                            return
                        }
                        
                        let updatedUser = User(
                            from: combineDictionaries(
                                [newUser.toDictionary(), ["userDetails": resultUserDetails as Any]]
                            )
                        )
                        self.session = updatedUser
                        self.initStateDidChangeListener()
                        self.isLoading = false
                    }
                    return
                }
                
                self.addUserUniqueName(user: newUser) { resultUpdatedUser, error in
                    self.session = resultUpdatedUser
                    self.initStateDidChangeListener()
                    self.isLoading = false
                }
            }
        }
    }
    
    func register(name: String, email: String, passwd: String, uiImage: UIImage) {
        guard let path = environment.plistDictionary?["PROFILE_IMAGES_PATH"] as? String else {
            fatalError("Wrong environment variable value: \"PROFILE_IMAGES_PATH\"")
        }
        self.removeStateDidChangeListener()
        self.isLoading = true
        let imageName = uiImage.accessibilityLabel ?? "Unknown"
        let imagePath = "\(path)\(imageName).jpg"
        
        fbSrotageDataProvider.uploadImage(uiImage, path: imagePath) { result in
            switch result {
            case .success(let url):
                self.userDataAuthProvider.register(email, passwd) { registerResultFbUser, error in
                    guard let fbUser = registerResultFbUser else {
                        self.isLoading = false
                        return
                    }
                    
                    var newUser = User(firebaseUser: fbUser)
                    self.userDataAuthProvider.updatePhotoURL(url: url.data) { updateResultFbUserPhotoURL, error in
                        newUser.photoURL = updateResultFbUserPhotoURL?.photoURL
                        self.userDataAuthProvider.updateDisplayName(fullName: name) { updateResultFbUserDisplayName, error in
                            newUser.fullName = updateResultFbUserDisplayName?.displayName
                            
                            self.addUserUniqueName(user: newUser) { resultUpdatedUser, error in
                                self.session = resultUpdatedUser
                                self.initStateDidChangeListener()
                                self.isLoading = false
                            }
                        }
                    }
                }
            case .failure(let error):
                ErrorHandler.handleAPIError(error)
                self.isLoading = false
            }
        }
    }
    
    func signOut() {
        userDataAuthProvider.signOut { result, error in
        }
    }
    
    private func addUserUniqueName(user: User, completion: @escaping (User?, Error?) -> Void) {
        self.userDataProvider.addUserUniqueName(user: user) { result, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            let userDictionary = user.toDictionary()
            let updatedUser = User(
                from: combineDictionaries(
                    [userDictionary, ["userDetails": ["uniqueUsername": result]]]
                )
            )
            
            completion(updatedUser, nil)
        }
    }
    
    private func initStateDidChangeListener() {
        listener = Auth.auth().addStateDidChangeListener { (auth, resultFbUser) in
            guard let fbUser = resultFbUser else {
                self.session = nil
                self.isLoading = false
                return
            }
            
            let newUser = User(firebaseUser: fbUser)
            self.userDataProvider.getUserDetais(user: newUser) { resultUserDetails, error in
                guard error == nil else {
                    self.session = nil
                    self.isLoading = false
                    return
                }
                
                let updatedUser = User(
                    from: combineDictionaries(
                        [newUser.toDictionary(), ["userDetails": resultUserDetails as Any]]
                    )
                )
                self.session = updatedUser
                self.isLoading = false
            }
        }
    }
    private func removeStateDidChangeListener() {
        if let l = listener {
            Auth.auth().removeStateDidChangeListener(l)
        }
    }
    
    deinit {
        self.removeStateDidChangeListener()
    }
}
