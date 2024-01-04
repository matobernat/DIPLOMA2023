//
//  FirebaseStoragePdfRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/04/2023.
//

import Foundation
import FirebaseStorage

class FirebaseStoragePdfRepository: PdfRepository {
    
    private let storage = Storage.storage()

    func uploadPdf(_ data: Data, completion: @escaping (Result<String, Error>) -> ()) {
        let storageRef = storage.reference().child(UUID().uuidString + ".pdf")
        
        storageRef.putData(data, metadata: StorageMetadata(dictionary: ["contentType": "application/pdf"])) { (_, error) in
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
                    completion(.failure(NSError(domain: "FirebasePdfRepository",
                                                code: -1,
                                                userInfo: [NSLocalizedDescriptionKey: "URL is nil"])))
                }
            }
        }
    }

    func fetchPdf(with url: String?, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = url else {
            completion(.failure(NSError(domain: "FirebasePdfRepository",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "URL is nil"])))
            return
        }

        let storageRef = storage.reference(forURL: url)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "FirebasePdfRepository",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "PDF data is nil"])))
            }
        }
    }

    func deletePdf(url: String?, completion: @escaping (Result<Void, Error>) -> ()) {
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

    func updatePdf(oldUrl: String?, newData: Data, completion: @escaping (Result<String, Error>) -> ()) {
        uploadPdf(newData) { uploadResult in
            switch uploadResult {
            case .success(let newUrl):
                self.deletePdf(url: oldUrl) { deleteResult in
                    switch deleteResult {
                    case .success:
                        completion(.success(newUrl))
                    case .failure(let deleteError):
                        // if the deletion of old PDF fails, ignore it and return new URL
                        completion(.success(newUrl))
                    }
                }
            case .failure(let uploadError):
                completion(.failure(uploadError))
            }
        }
    }
}
