//
//  FirebaseStorageDataProvider.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 02.04.2023.
//

import Firebase
import FirebaseStorage

class FirebaseStorageDataProvider {
    private let storageRef = Storage.storage().reference()
    
    func uploadImage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "Invalid image data", code: 400, userInfo: nil)))
            return
        }
        
        let imageRef = storageRef.child(path)
        imageRef.putData(data) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                imageRef.downloadURL { (url, error) in
                    if let url = url {
                        completion(.success(url.absoluteString))
                    } else {
                        completion(.failure(error ?? NSError(domain: "Unknown error", code: 500, userInfo: nil)))
                    }
                }
            }
        }
    }
    
    func downloadImage(path: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let imageRef = storageRef.child(path)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let data = data {
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(NSError(domain: "Invalid image data", code: 400, userInfo: nil)))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 500, userInfo: nil)))
            }
        }
    }
}

