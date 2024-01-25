//
//  ImageRepository.swift
//  Diploma_2023
//
<<<<<<< HEAD
//  Created by Martin Bernát on 29/04/2023.
//

import Foundation
import SwiftUI


protocol ImageRepository {
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> ())
    func fetchImage(with url: String?, completion: @escaping (Result<UIImage, Error>) -> ())
    func deleteImage(url: String?, completion: @escaping (Result<Void, Error>) -> ())
    func updateImage(oldUrl: String?, newImage: UIImage, completion: @escaping (Result<String, Error>) -> ())

}
=======
//  Created by Martin Bernát on 04/01/2024.
//

import Foundation
>>>>>>> main
