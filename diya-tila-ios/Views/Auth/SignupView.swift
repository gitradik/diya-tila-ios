//
//  RigisterView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI
import SwiftUIX

struct SignupView: View {
    let signUp: (_ name: String, _ email: String, _ password: String, _ image: UIImage?) -> Void
    let signUpGoogle: () -> Void
    
    @State var selectedImage: UIImage?
    @State var showingImagePicker = false
    @State var image: UIImage?
    
    private let passwordField = FormField(type: .password, name: "password", defaultValue: "", placeholder: "Password:", validationRules: [.required, .password])
    
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
                                Image(systemName: "plus")
                                    .sizeToFit(width: 20, height: 20)
                                    .overlay(Circle().stroke(Color.primaryColor, lineWidth: 3))
                                    .onTapGesture {
                                        self.showingImagePicker = true
                                    }
                            }
                        }
                    }.frame(width: photoSize.width, height: photoSize.height)

                }
            }.scenePadding(.bottom)
            
            Form(fields: [
                FormField(type: .text, name: "fullName", defaultValue: "", placeholder: "Full name:", validationRules: [.required]),
                FormField(type: .email, name: "email", defaultValue: "", placeholder: "Email:", validationRules: [.required, .email]),
                passwordField,
                FormField(type: .password, name: "confirmPassword", defaultValue: "", placeholder: "Confirm password:", validationRules: [.required, .password, .custom({ value in
                    passwordField.value == value
                })])
            ], submitButtonLabel: "Sign Up") { fields in
                guard let image = image else {
                    return
                }
                
                if let fullNameValue = fields["fullName"]?.value,
                    let emailValue = fields["email"]?.value,
                   let passwordValue = fields["password"]?.value {
                    signUp(fullNameValue, emailValue, passwordValue, image)
                }
            }.scenePadding(.bottom)
            
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

