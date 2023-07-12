//
//  ImagePickerControllerView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 28/06/2023.
//

import SwiftUI

// OLDER FUNCTIONING

struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary


    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var images: [UIImage]
        var parent: ImagePickerController


        init(images: Binding<[UIImage]>, parent: ImagePickerController) {
            _images = images
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                images.append(uiImage)
                parent.presentationMode.wrappedValue.dismiss()
            }
        }


        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(images: $images, parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerController>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerController>) {}
}


struct ImagePickerBaseView<ContentView>: View where ContentView: View {
    @State var pickerState: (showing: Bool, sourceType: UIImagePickerController.SourceType)?
    var onImagePicked: (UIImage) -> Void

    var contentView: (@escaping() -> Void) -> ContentView

    var body: some View {
        VStack {
            contentView({ self.triggerActionSheet() })
        }
        .sheet(isPresented: Binding(get: { pickerState?.showing ?? false }, set: { if !$0 { pickerState = nil } })) {
            if let pickerState = pickerState {
                ImagePickerControllerProgressAlbum(onImagePicked: onImagePicked, sourceType: pickerState.sourceType)
            }
        }
    }

    
    func triggerActionSheet() {
//        ImagePickerBaseView.showActionSheet(pickerState: $pickerState, images: $images)
        ImagePickerBaseView.showActionSheet(pickerState: $pickerState)

    }
    
    static func showActionSheet(pickerState: Binding<(showing: Bool, sourceType: UIImagePickerController.SourceType)?>) {
        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Add from Library", style: .default, handler: { _ in
            pickerState.wrappedValue = (showing: true, sourceType: .photoLibrary)
        }))

        actionSheet.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                pickerState.wrappedValue = (showing: true, sourceType: .camera)
            } else {
                print("Camera not available")
            }
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let presenter = UIApplication.shared.windows.first?.rootViewController {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = presenter.view
                popoverController.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            presenter.present(actionSheet, animated: true, completion: nil)
        }
    }

}

//struct ImagePickerBaseView<ContentView>: View where ContentView: View {
//    @State var pickedImages: [UIImage] = []
//    @State var pickerState: (showing: Bool, sourceType: UIImagePickerController.SourceType)?
//
//    var contentView: ([UIImage], @escaping() -> Void) -> ContentView
//
//    var body: some View {
//        VStack {
//            contentView(pickedImages, { self.triggerActionSheet() })
//        }
//        .sheet(isPresented: Binding(get: { pickerState?.showing ?? false }, set: { if !$0 { pickerState = nil } })) {
//            if let pickerState = pickerState {
//                ImagePickerControllerProgressAlbum(onImagePicked: { image in
//                    pickedImages.append(image)
//                }, sourceType: pickerState.sourceType)
//            }
//        }
//    }
//
//    func triggerActionSheet() {
//        ImagePickerBaseView.showActionSheet(pickerState: $pickerState)
//    }
//
//    static func showActionSheet(pickerState: Binding<(showing: Bool, sourceType: UIImagePickerController.SourceType)?>) {
//        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Add from Library", style: .default, handler: { _ in
//            pickerState.wrappedValue = (showing: true, sourceType: .photoLibrary)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { _ in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                pickerState.wrappedValue = (showing: true, sourceType: .camera)
//            } else {
//                print("Camera not available")
//            }
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        if let presenter = UIApplication.shared.windows.first?.rootViewController {
//            if let popoverController = actionSheet.popoverPresentationController {
//                popoverController.sourceView = presenter.view
//                popoverController.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
//                popoverController.permittedArrowDirections = []
//            }
//            presenter.present(actionSheet, animated: true, completion: nil)
//        }
//    }
//}








struct ImagePickerControllerProgressAlbum: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var onImagePicked: (UIImage) -> Void
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var onImagePicked: (UIImage) -> Void
        var parent: ImagePickerControllerProgressAlbum

        init(onImagePicked: @escaping (UIImage) -> Void, parent: ImagePickerControllerProgressAlbum) {
            self.onImagePicked = onImagePicked
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                onImagePicked(uiImage)
                parent.presentationMode.wrappedValue.dismiss()
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onImagePicked: onImagePicked, parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerControllerProgressAlbum>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerControllerProgressAlbum>) {}
}






//struct ImagePickerBaseView<ContentView>: View where ContentView: View {
//    @State var pickerState: (showing: Bool, sourceType: UIImagePickerController.SourceType)?
//
//    var contentView: (@escaping(UIImage) -> Void, @escaping() -> Void) -> ContentView
//
//    var body: some View {
//        VStack {
//            contentView({ image in
//                // Pass the picked image up to the parent view
//                self.onImagePicked(image)
//            }, { self.triggerActionSheet() })
//        }
//        .sheet(isPresented: Binding(get: { pickerState?.showing ?? false }, set: { if !$0 { pickerState = nil } })) {
//            if let pickerState = pickerState {
//                ImagePickerController(onImagePicked: { image in
//                    // Pass the picked image up to the parent view
//                    self.onImagePicked(image)
//                }, sourceType: pickerState.sourceType)
//            }
//        }
//    }
//
//    func onImagePicked(_ image: UIImage) {
//        // This is where you'd handle the image, i.e. upload it to the server
//    }
//
//    func triggerActionSheet() {
//        ImagePickerBaseView.showActionSheet(pickerState: $pickerState)
//    }
//
//    static func showActionSheet(pickerState: Binding<(showing: Bool, sourceType: UIImagePickerController.SourceType)?>) {
//        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Add from Library", style: .default, handler: { _ in
//            pickerState.wrappedValue = (showing: true, sourceType: .photoLibrary)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { _ in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                pickerState.wrappedValue = (showing: true, sourceType: .camera)
//            } else {
//                print("Camera not available")
//            }
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        if let presenter = UIApplication.shared.windows.first?.rootViewController {
//            if let popoverController = actionSheet.popoverPresentationController {
//                popoverController.sourceView = presenter.view
//                popoverController.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
//                popoverController.permittedArrowDirections = []
//            }
//            presenter.present(actionSheet, animated: true, completion: nil)
//        }
//    }
//}





