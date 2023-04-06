//
//  RigisterView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI
import SwiftUIX

struct SignupView: View {
    let signUp: ((_ name: String, _ email: String, _ passwd: String, _ image: UIImage?) -> Void)
    let signUpGoogle: () -> Void
    
    @State var selectedImage: UIImage?
    @State var showingImagePicker = false
    
    @State private var name: String = ""
    @State private var passwd: String = ""
    @State private var email: String = ""
    @State var image: UIImage?
    
    let photoSize = (width: CGFloat(120), height: CGFloat(120))
    
    var body: some View {
        VStack {
            HStack {
                if let selectedImage = selectedImage {
                    VStack {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                .clipShape(Circle())
                        } else {
                            ActivityIndicator()
                                .animated(true)
                                .style(.regular)
                        }
                    }.frame(width: photoSize.width, height: photoSize.height)
                    .onAppear {
                        NNImageCropAndScale(image: selectedImage, width: photoSize.width, height: photoSize.height).detectFace { result in
                            self.image = try? result.get()
                        }
                    }
                } else {
                    ZStack(alignment: .center) {
                        Image("User")
                            .sizeToFit(width: photoSize.width, height: photoSize.height)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image("Plus")
                                    .sizeToFit(width: 25, height: 25)
                                    .overlay(Circle().stroke(Color.secondaryColor, lineWidth: 3))
                                    .onTapGesture {
                                        self.showingImagePicker = true
                                    }
                            }
                        }
                    }.frame(width: photoSize.width, height: photoSize.height)

                }
            }.scenePadding(.bottom)
            
            TextField("Full Name", text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $passwd)
                .textFieldStyle(.roundedBorder)
            
            // Button for registration
            Button(action: {
                guard !name.isEmpty && !email.isEmpty && !passwd.isEmpty && image != nil else {
                    return
                }
                
                signUp(name, email, passwd, image)
            }){
                Text("Register")
                    .padding(12)
                    .border(Color.primaryColor)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.primaryColor)
            .cornerRadius(10)
            .scenePadding(.bottom)
            
            OAuthSignInWithGoogleButton(buttonText: Text("Register with Google")) {
                signUpGoogle()
            }
            Spacer()
        }
        .scenePadding(.top)
        .scenePadding(.horizontal)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        
        Spacer()
    }
}

