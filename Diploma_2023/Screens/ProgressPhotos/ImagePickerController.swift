//
//  ImagePickerController.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 28/06/2023.
//

import SwiftUI

struct ImageView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        @Environment(\.presentationMode) var presentationMode

        init(image: Binding<UIImage?>, presentationMode: Binding<PresentationMode>) {
            _image = image
            _presentationMode = presentationMode
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image = uiImage
                presentationMode.dismiss()
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, presentationMode: $presentationMode)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImageView>) {}
}

