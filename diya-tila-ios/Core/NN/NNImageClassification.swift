//
//  ImageClassification.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 03.04.2023.
//

import SwiftUI
import Vision

class NNImageClassification {
    private var classification: String = ""
    
    var getClassification: String {
        get { classification }
    }
    
    private let model: VNCoreMLModel = {
        do {
            let configuration = MLModelConfiguration()
            return try VNCoreMLModel(for: SqueezeNet(configuration: configuration).model)
        } catch {
            fatalError("Failed to create VNCoreMLModel: \(error)")
        }
    }()
    
    init(image: UIImage) {
        self.classifyImage(image, with: self.model)
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
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        do {
            try handler.perform([request])
        } catch {
            self.classification = "Error: \(error.localizedDescription)"
        }
    }
}
