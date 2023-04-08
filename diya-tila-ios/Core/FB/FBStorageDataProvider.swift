//
//  FirebaseStorageDataProvider.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 02.04.2023.
//

import Firebase
import FirebaseStorage

class FBStorageDataProvider {
    private let storageRef = Storage.storage().reference()
    
    func uploadImage(_ image: UIImage, path: String, completion: @escaping (Result<APIResponse<URL>, APIError>) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(.invalidResponse(nil)))
            return
        }
        
        // MARK: Test failture
        let imageRef = storageRef.child("images/"+path)
        imageRef.putData(data) { (metadata, error) in
            if let error = error {
                completion(.failure(.requestFailed(error.localizedDescription)))
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(.requestFailed(error.localizedDescription)))
                    return
                }
                
                guard let url = url else {
                    completion(.failure(.invalidResponse(nil)))
                    return
                }
                
                completion(.success(APIResponse<URL>(data: url)))
            }
        }
    }
    
    func downloadImage(path: String, completion: @escaping (Result<APIResponse<UIImage>, APIError>) -> Void) {
        let imageRef = storageRef.child(path)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let data = data {
                if let image = UIImage(data: data) {
                    completion(.success(APIResponse<UIImage>(data: image)))
                } else {
                    completion(.failure(.invalidResponse(nil)))
                }
            } else if let error = error {
                completion(.failure(.requestFailed(error.localizedDescription)))
            } else {
                completion(.failure(.invalidResponse(nil)))
            }
        }
    }
}

