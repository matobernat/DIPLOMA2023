//
//  AsyncImage.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 28/06/2023.
//

import Foundation
import SwiftUI


//MARK: this might be used in case for iOS14 or lower, since it does not support SwiftUI AsyncImage
struct MyAsyncImage: View {
    @ObservedObject private var asyncLoader: AsyncImageLoader
    private let placeholder: UIImage?
    private let image: UIImage?

    init(url: String?, placeholder: UIImage? = nil, image: UIImage? = nil) {
        self.placeholder = placeholder
        self.image = image
        self.asyncLoader = AsyncImageLoader(url: url)
    }

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
        } else if let image = asyncLoader.loader?.image {
            Image(uiImage: image)
                .resizable()
        } else {
            Image(uiImage: placeholder ?? UIImage(systemName: "person.fill.questionmark")!)
                .resizable()
        }
    }
}



class AsyncImageLoader: ObservableObject {
    @Published var loader: ImageLoader?
    
    init(url: String?) {
        if let url = url {
            loader = ImageLoader(url: url)
        }
    }
}


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    init(url: String) {
        loadImage(from: url)
    }
    
    func loadImage(from url: String) {
        // Assume imageRepository is an instance of ImageRepository
        AppDependencyContainer.shared.imageRepository.fetchImage(with: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            case .failure(let error):
                print("Failed to load image from URL: \(url), error: \(error)")
            }
        }
    }
}
