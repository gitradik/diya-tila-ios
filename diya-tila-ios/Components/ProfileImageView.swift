//
//  ProfileImageView.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 03.04.2023.
//

import SwiftUI
import Vision

class ProfileImageView: UIImageView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @State private var classification: String = ""
    
    private let model: VNCoreMLModel = {
        do {
            let configuration = MLModelConfiguration()
            return try VNCoreMLModel(for: SqueezeNet(configuration: configuration).model)
        } catch {
            fatalError("Failed to create VNCoreMLModel: \(error)")
        }
    }()
    
    var body: some View {
        VStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
            } else {
                Text("Select an image to classify")
            }
            Text(classification)
                .padding()
            Button("Select Image") {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let rootViewController = windowScene.windows.first?.rootViewController {
                        rootViewController.present(picker, animated: true)
                    }
                }
            }
            .padding()
        }
        .onAppear() {
            self.classification = ""
        }
        .onChange(of: image) { _ in
            if let image = self.image {
                self.classifyImage(image, with: self.model)
            }
        }
    }
    
    func classifyImage(_ image: UIImage, with model: VNCoreMLModel) {
        guard let ciImage = CIImage(image: image) else { return }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self.classification = "Unable to classify image"
                return
            }
            
            self.classification = "\(topResult.identifier) (\(topResult.confidence * 100)%)"
            print("classification", self.classification)
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        do {
            print(">>>>>>>>>>>>>>>> 1")
            try handler.perform([request])
            print(">>>>>>>>>>>>>>>> 2")
        } catch {
            self.classification = "Error: \(error.localizedDescription)"
        }
    }
}






