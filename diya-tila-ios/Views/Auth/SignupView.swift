//
//  RigisterView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 31.03.2023.
//

import SwiftUI

struct SignupView: View {
    let signUp: ((_ name: String, _ email: String, _ passwd: String, _ image: UIImage?) -> Void)?
    
    @State var image: UIImage?
    @State var showingImagePicker = false
    @State private var name: String = ""
    @State private var passwd: String = ""
    @State private var email: String = ""
    
    var body: some View {
        VStack {
            HStack {
                if let image = image {
                    NNImageCropAndScaleView(image: image, width: 200, height: 200)
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 200, height: 200)
//                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                        .clipShape(Circle())
//                        .shadow(radius: 4)
//                        .onAppear {
//                            let imgClass = NNImageClassification(image: image)
//                            print(imgClass.getClassification)
//                        }
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
                    .frame(width: 200, height: 200)
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
            Button(action: {
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
            ImagePicker(image: $image)
        }
        Spacer()
    }
}
