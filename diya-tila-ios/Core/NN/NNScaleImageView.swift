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
// Increase the size of the bounding box by a certain factor to "zoom out" the face
//let zoomOutFactor: CGFloat = 1.2
//let scaledWidth = faceBoundingBox.boundingBox.width * ciImage.extent.width * zoomOutFactor
//let scaledHeight = faceBoundingBox.boundingBox.height * ciImage.extent.height * zoomOutFactor
//let x = faceBoundingBox.boundingBox.origin.x * ciImage.extent.width - (scaledWidth - faceBoundingBox.boundingBox.width * ciImage.extent.width) / 2
//let y = faceBoundingBox.boundingBox.origin.y * ciImage.extent.height - (scaledHeight - faceBoundingBox.boundingBox.height * ciImage.extent.height) / 2
//let rect = CGRect(x: x, y: y, width: scaledWidth, height: scaledHeight)
//let croppedImage = ciImage.cropped(to: rect)

struct NNScaledImageView: View {
    let image: UIImage
    let width: CGFloat
    let height: CGFloat
    let zoomOutFactor: CGFloat = 1.2
    
    @State private var croppedImage: UIImage?
    
    var body: some View {
        VStack {
            if let croppedImage = croppedImage {
                Image(uiImage: croppedImage)
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
                        scaleImage(scaleX: width/ciImage.extent.width, scaleY: height/ciImage.extent.height)
                        return
                    }
                    // Scale the image based on the size of the detected face
                    let scaledImageSize = CGSize(width: faceBoundingBox.boundingBox.width * ciImage.extent.width,
                                                 height: faceBoundingBox.boundingBox.height * ciImage.extent.height)
                    let scaleX = width / scaledImageSize.width
                    let scaleY = height / scaledImageSize.height
                    cropImage(faceBoundingBox: faceBoundingBox, scaleX: scaleX, scaleY: scaleY)
                } catch {
                    print(error)
                }
            }
        }
        
        func cropImage(faceBoundingBox: VNFaceObservation, scaleX: CGFloat, scaleY: CGFloat) {
            let zoomOutFactor: CGFloat = 0.2 // Adjust this value to change the zoom factor
            let cropRect = CGRect(x: (faceBoundingBox.boundingBox.origin.x - zoomOutFactor / 2.0) * image.size.width,
                                  y: ((1 - faceBoundingBox.boundingBox.origin.y - faceBoundingBox.boundingBox.height) - zoomOutFactor / 2.0) * image.size.height,
                                  width: (faceBoundingBox.boundingBox.width + zoomOutFactor) * image.size.width,
                                  height: (faceBoundingBox.boundingBox.height + zoomOutFactor) * image.size.height)

            
            guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return }
            
            let croppedImage = UIImage(cgImage: cgImage)
//            let scaledImage = croppedImage.scaledImage(toSize: CGSize(width: width - 50, height: height - 50))
            
            DispatchQueue.main.async {
                self.croppedImage = croppedImage
            }
        }
    
    func scaleImage(scaleX: CGFloat, scaleY: CGFloat) {
        let scaleTransform = CIFilter(name: "CILanczosScaleTransform")!
        scaleTransform.setValue(CIImage(image: image), forKey: "inputImage")
        scaleTransform.setValue(scaleX, forKey: "inputScale")
        scaleTransform.setValue(scaleY, forKey: "inputAspectRatio")
        
        guard let outputImage = scaleTransform.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return }
        DispatchQueue.main.async {
            croppedImage = UIImage(cgImage: cgImage)
        }
    }
    
    init(image: UIImage, width: CGFloat, height: CGFloat) {
        self.image = image
        self.width = width
        self.height = height
    }
}

extension UIImage {
    func scaledImage(toSize size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
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
