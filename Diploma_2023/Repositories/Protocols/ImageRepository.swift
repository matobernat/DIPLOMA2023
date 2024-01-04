//
//  ImageRepository.swift
//  Diploma_2023
//
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
