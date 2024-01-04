//
//  MockImageStorageRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation
import SwiftUI


class MockImageRepository: ImageRepository {
    private var mockImages: [String: UIImage] = [:]  // Dictionary to store images by URL

    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> ()) {
        let fakeURL = UUID().uuidString  // Generate a fake URL
        mockImages[fakeURL] = image
        completion(.success(fakeURL))
    }

    func fetchImage(with url: String?, completion: @escaping (Result<UIImage, Error>) -> ()) {
        guard let url = url, let image = mockImages[url] else {
            completion(.failure(NSError(domain: "MockImageRepository",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Image not found"])))
            return
        }
        completion(.success(image))
    }

    func deleteImage(url: String?, completion: @escaping (Result<Void, Error>) -> ()) {
        guard let url = url else {
            completion(.success(()))
            return
        }
        mockImages.removeValue(forKey: url)
        completion(.success(()))
    }

    func updateImage(oldUrl: String?, newImage: UIImage, completion: @escaping (Result<String, Error>) -> ()) {
        deleteImage(url: oldUrl) { _ in }
        uploadImage(newImage) { result in
            completion(result)
        }
    }
}


