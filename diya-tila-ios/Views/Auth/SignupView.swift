//
//  RigisterView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct SignupView: View {
    let signUp: ((_ name: String, _ email: String, _ passwd: String, _ image: UIImage?) -> Void)?
    
    @State var selectedImage: UIImage?
    @State var showingImagePicker = false
    
    @State private var name: String = ""
    @State private var passwd: String = ""
    @State private var email: String = ""
    @State var image: UIImage?
    
    let photoSize = (width: CGFloat(170), height: CGFloat(170))
    
    var body: some View {
        VStack {
            HStack {
                if let selectedImage = selectedImage {
                    VStack {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        } else {
                            ProgressView()
                        }
                    }.frame(width: photoSize.width, height: photoSize.height)
                    .onAppear {
                        NNImageCropAndScale(image: selectedImage, width: photoSize.width, height: photoSize.height).detectFace { result in
                            self.image = try? result.get()
                        }
                    }
                } else {
                    ZStack(alignment: .center) {
                        LottieAnimationWithFile(lottieFile: "GreenAnimation", loopMode: .repeat(2.0))
                            .aspectRatio(contentMode: .fill)
                        Text("Pick photo")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: photoSize.width, height: photoSize.height)
                    .onTapGesture {
                        self.showingImagePicker = true
                    }
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
                
                if let fn = signUp {
                    fn(name, email, passwd, image)
                }
            }){
                Text("Register")
                    .padding(12)
                    .border(.cyan)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.white)
            .background(.cyan)
            .cornerRadius(10)
        }
        .scenePadding(.top)
        .scenePadding(.horizontal)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        
        Spacer()
    }
}

