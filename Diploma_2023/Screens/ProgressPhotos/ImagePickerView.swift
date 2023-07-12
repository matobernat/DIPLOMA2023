//
//  ImagePickerView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 28/06/2023.
//

import SwiftUI

struct ImagePickerView: View {
    @State var image: UIImage?
    @State var showingImagePicker = false

    var body: some View {
        VStack {
            Image(uiImage: image ?? UIImage())
                .resizable()
                .scaledToFit()

            Button("Select Image") {
                showingImagePicker = true
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImageView(image: $image)
        }
    }

}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
    }
}
