//
//  FirebaseStorageImageDataStore.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/04/2023.
//

import Foundation
import FirebaseStorage
import UIKit


//TODO:  Not yet implemented nor used, probably in future.

//class FirebaseStorageImageDataStore {
//    private let storage = Storage.storage()
//
//    // Upload an image to Firebase Storage and return the download URL
//    func uploadImage(_ data: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
//        let imageName = UUID().uuidString
//        let reference = storage.reference().child("images/\(imageName)")
//
//        reference.putData(data, metadata: nil) { metadata, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            reference.downloadURL { url, error in
//                if let error = error {
//                    completion(.failure(error))
//                } else if let url = url {
//                    completion(.success(url.absoluteString))
//                }
//            }
//        }
//    }
//
//    // other operations like delete image, fetch image etc.
//}

