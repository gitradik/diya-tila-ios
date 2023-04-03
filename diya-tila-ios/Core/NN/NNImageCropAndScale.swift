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

class NNImageCropAndScale {
    let image: UIImage
    let width: CGFloat
    let height: CGFloat
    let zoomOutFactor: CGFloat = 0.5
    
    init(image: UIImage, width: CGFloat, height: CGFloat) {
        self.image = image
        self.width = width
        self.height = height
    }
    
    func detectFace(completion: @escaping (Result<UIImage, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let ciImage = CIImage(image: self.image) else { return }
            let orientation = CGImagePropertyOrientation(self.image.imageOrientation)
            let faceDetectionRequest = VNDetectFaceRectanglesRequest()
            faceDetectionRequest.usesCPUOnly = true
            let requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                var changedImage: UIImage? = nil
                try requestHandler.perform([faceDetectionRequest])
                guard let faceBoundingBox = faceDetectionRequest.results?.first as? VNFaceObservation else {
                    // If no face is detected, simply scale the image
                    changedImage = self.scaleImage(scaleX: self.width/ciImage.extent.width, scaleY: self.height/ciImage.extent.height)
                    DispatchQueue.main.async {
                        completion(.success(changedImage!))
                    }
                    return
                }
                // Scale the image based on the size of the detected face
                let scaledImageSize = CGSize(width: faceBoundingBox.boundingBox.width * ciImage.extent.width,
                                             height: faceBoundingBox.boundingBox.height * ciImage.extent.height)
                let scaleX = self.width / scaledImageSize.width
                let scaleY = self.height / scaledImageSize.height
                changedImage = self.cropImage(faceBoundingBox: faceBoundingBox, scaleX: scaleX, scaleY: scaleY)
                
                DispatchQueue.main.async {
                    completion(.success(changedImage!))
                }
            } catch {                
                completion(.failure(error))
            }
        }
    }
    
    private func cropImage(faceBoundingBox: VNFaceObservation, scaleX: CGFloat, scaleY: CGFloat) -> UIImage {
        let cropRect = CGRect(x: (faceBoundingBox.boundingBox.origin.x - zoomOutFactor / 2.0) * image.size.width,
                              y: ((1 - faceBoundingBox.boundingBox.origin.y - faceBoundingBox.boundingBox.height) - zoomOutFactor / 2.0) * image.size.height,
                              width: (faceBoundingBox.boundingBox.width + zoomOutFactor) * image.size.width,
                              height: (faceBoundingBox.boundingBox.height + zoomOutFactor) * image.size.height)
        
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return image }
        let croppedImage = UIImage(cgImage: cgImage)
        
        return croppedImage
    }
    
    private func scaleImage(scaleX: CGFloat, scaleY: CGFloat) -> UIImage {
        let scaleTransform = CIFilter(name: "CILanczosScaleTransform")!
        scaleTransform.setValue(CIImage(image: image), forKey: "inputImage")
        scaleTransform.setValue(scaleX, forKey: "inputScale")
        scaleTransform.setValue(scaleY, forKey: "inputAspectRatio")
        
        guard let outputImage = scaleTransform.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return image }
        return UIImage(cgImage: cgImage)
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
