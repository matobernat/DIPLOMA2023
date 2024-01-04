//
//  FirebaseStorageImageRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/04/2023.
//

import Foundation
import FirebaseStorage
import UIKit


import FirebaseStorage


class FirebaseStorageImageRepository: ImageRepository {
    
    private let storage = Storage.storage()

    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> ()) {
        let storageRef = storage.reference().child(UUID().uuidString)
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(.failure(NSError(domain: "FirebaseImageRepository",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Failed to create JPEG data"])))
            return
        }
        storageRef.putData(imageData, metadata: StorageMetadata(dictionary: ["contentType": "image/jpeg"])) { (_, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(NSError(domain: "FirebaseImageRepository",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "URL is nil"])))
                }
            }
        }
    }


    func fetchImage(with url: String?, completion: @escaping (Result<UIImage, Error>) -> ()) {
        guard let url = url else {
            completion(.failure(NSError(domain: "FirebaseImageRepository",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "URL is nil"])))
            return
        }

        let storageRef = storage.reference(forURL: url)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(NSError(domain: "FirebaseImageRepository",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Image data is nil"])))
            }
        }
    }

    
    
    func deleteImage(url: String?, completion: @escaping (Result<Void, Error>) -> ()) {
        guard let url = url else {
            completion(.success(()))
            return
        }
        
        let ref = storage.reference(forURL: url)
        ref.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    
    func updateImage(oldUrl: String?, newImage: UIImage, completion: @escaping (Result<String, Error>) -> ()) {
        uploadImage(newImage) { uploadResult in
            switch uploadResult {
            case .success(let newUrl):
                self.deleteImage(url: oldUrl) { deleteResult in
                    switch deleteResult {
                    case .success:
                        completion(.success(newUrl))
                    case .failure(let deleteError):
                        // if the deletion of old image fails, ignore it and return new URL
                        completion(.success(newUrl))
                    }
                }
            case .failure(let uploadError):
                completion(.failure(uploadError))
            }
        }
    }

    
}


