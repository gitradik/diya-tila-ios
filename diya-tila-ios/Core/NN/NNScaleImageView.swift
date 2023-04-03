//
//  ScaleImage.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 03.04.2023.
//

//
//  ImageClassification.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 03.04.2023.
//
import SwiftUI
import Vision

struct NNScaledImageView: View {
    let image: UIImage
    let width: CGFloat
    let height: CGFloat
    
    @State private var scaledImage: UIImage?
    
    var body: some View {
        VStack {
            if let scaledImage = scaledImage {
                Image(uiImage: scaledImage)
                    .resizable()
                    .scaledToFill()
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .clipShape(Circle())
                    .shadow(radius: 4)
            } else {
                ProgressView()
            }
        }
        .frame(width: width, height: height)
        .onAppear {
            detectFace()
        }
    }
    
    func detectFace() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let ciImage = CIImage(image: image) else { return }
            let orientation = CGImagePropertyOrientation(image.imageOrientation)
            let faceDetectionRequest = VNDetectFaceRectanglesRequest()
            faceDetectionRequest.usesCPUOnly = true
            let requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try requestHandler.perform([faceDetectionRequest])
                guard let faceBoundingBox = faceDetectionRequest.results?.first as? VNFaceObservation else {
                    // If no face is detected, simply scale the image
                    scaleImage(scaleX: width/ciImage.extent.width)
                    return
                }
                // Scale the image based on the size of the detected face
                let scaledImageSize = CGSize(width: faceBoundingBox.boundingBox.width * ciImage.extent.width,
                                             height: faceBoundingBox.boundingBox.height * ciImage.extent.height)
                let scaleX = width / scaledImageSize.width
                scaleImage(scaleX: scaleX)
            } catch {
                print(error)
            }
        }
    }
    
    func scaleImage(scaleX: CGFloat) {
        let scaleTransform = CIFilter(name: "CILanczosScaleTransform")!
        scaleTransform.setValue(CIImage(image: image), forKey: "inputImage")
        scaleTransform.setValue(scaleX, forKey: "inputScale")
        
        guard let outputImage = scaleTransform.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return }
        DispatchQueue.main.async {
            print("UIImage(cgImage: cgImage)", UIImage(cgImage: cgImage))
            scaledImage = UIImage(cgImage: cgImage)
        }
    }
    
    init(image: UIImage, width: CGFloat, height: CGFloat) {
        self.image = image
        self.width = width
        self.height = height
    }
}

extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up:
            self = .up
        case .upMirrored:
            self = .upMirrored
        case .down:
            self = .down
        case .downMirrored:
            self = .downMirrored
        case .left:
            self = .left
        case .leftMirrored:
            self = .leftMirrored
        case .right:
            self = .right
        case .rightMirrored:
            self = .rightMirrored
        }
    }
}

//import SwiftUI
//import Vision
//
//struct NNScaledImageView: View {
//    let image: UIImage
//    let width: CGFloat
//    let height: CGFloat
//
//    @State private var scaledImage: UIImage?
//
//    var body: some View {
//        VStack {
//            if let scaledImage = scaledImage {
//                Image(uiImage: scaledImage)
//                    .resizable()
//                    .scaledToFill()
//                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                    .clipShape(Circle())
//                    .shadow(radius: 4)
//            } else {
//                ProgressView()
//            }
//        }
//        .frame(width: width, height: height)
//        .onAppear {
//            scaleImage()
//        }
//    }
//
//    func scaleImage() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            guard let ciImage = CIImage(image: image) else { return }
//
//            let scaleX = width / ciImage.extent.width
//            let scaleY = height / ciImage.extent.height
//            let scaleTransform = CIFilter(name: "CILanczosScaleTransform")!
//            scaleTransform.setValue(ciImage, forKey: "inputImage")
//            scaleTransform.setValue(scaleX, forKey: "inputScale")
//            scaleTransform.setValue(scaleY, forKey: "inputAspectRatio")
//
//            guard let outputImage = scaleTransform.outputImage,
//                  let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return }
//            DispatchQueue.main.async {
//                scaledImage = UIImage(cgImage: cgImage)
//            }
//        }
//    }
//
//    init(image: UIImage, width: CGFloat, height: CGFloat) {
//        self.image = image
//        self.width = width
//        self.height = height
//    }
//}

