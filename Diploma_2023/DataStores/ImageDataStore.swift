//
//  ImageDataStore.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 28/06/2023.
//

import Foundation
import SwiftUI

class ImageDataStore: ObservableObject {
    @Published var clientProfilePictures = [String: UIImage]()
    @Published var progressPhotoAlbums = [String: UIImage]()

    private var imageRepository: ImageRepository

    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }

    func uploadImage(_ image: UIImage, completion: @escaping (_ url: String?) -> ()) {
        imageRepository.uploadImage(image) { [weak self] url in
            guard let url = url, let self = self else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                self.clientProfilePictures[url] = image
                completion(url)
            }
        }
    }

    func fetchImage(with url: String) {
        imageRepository.fetchImage(with: url) { [weak self] image in
            guard let image = image, let self = self else { return }
            DispatchQueue.main.async {
                self.clientProfilePictures[url] = image
            }
        }
    }
}
