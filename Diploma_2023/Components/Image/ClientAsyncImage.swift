//
//  ClientAsyncImage.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 30/06/2023.
//

import SwiftUI

struct ClientAsyncImage: View {
    var placeholderImageName: String
    var imageUrl: String?
    var size: CGFloat
    
    var body: some View {

        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure(_), .empty:
//                    Image(placeholderImageName).resizable().scaledToFill()
                    ProgressView().frame(width: size, height: size)

                @unknown default:
//                    ProgressView().frame(width: size, height: size)
                    Image(placeholderImageName).resizable().scaledToFill()
                }
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
        } else {
            Image(placeholderImageName)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}




