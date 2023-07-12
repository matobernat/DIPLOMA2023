//
//  EditProfileImageView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 28/06/2023.
//

import SwiftUI


struct EditProfileImageViewOld: View {
    @Binding var localImage: UIImage?
    let imageUrl: String?
    let placeholderImageName: String
    let size: CGFloat

    @State private var showingImagePicker = false
    @State var pickerState: (showing: Bool, sourceType: UIImagePickerController.SourceType)?


    init(localImage: Binding<UIImage?>, placeholderImageName: String, imageUrl: String?, size: CGFloat) {
        _localImage = localImage
        self.placeholderImageName = placeholderImageName
        self.imageUrl = imageUrl
        self.size = size
    }

    var body: some View {
        ZStack {
            if let image = localImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ClientAsyncImage(placeholderImageName: placeholderImageName, imageUrl: imageUrl, size: size)
            }
            VStack {
                Spacer()
                Button(action: {
                    pickerState = (showing: true, sourceType: .photoLibrary)
//                    showingImagePicker = true
                }) {
                    Text("Edit")
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.black.opacity(0.7))
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .sheet(isPresented: Binding(get: { pickerState?.showing ?? false }, set: { if !$0 { pickerState = nil } })) {
            if let pickerState = pickerState {
                ImagePickerController(images: Binding(get: { [localImage].compactMap { $0 } }, set: { localImage = $0.first }), sourceType: pickerState.sourceType)

            }
        }
    }
}

struct EditProfileImageView: View {
    @Binding var localImage: UIImage?
    let imageUrl: String?
    let placeholderImageName: String
    let size: CGFloat
    let isEditButtonShowing: Bool
    let onClearPhoto: () -> Void // closure for parent view

    
    @State var pickerState: (showing: Bool, sourceType: UIImagePickerController.SourceType)?

    
    init(localImage: Binding<UIImage?>,
         imageUrl: String?,
         placeholderImageName: String,
         size: CGFloat,
         isEditButtonShowing: Bool = true,
         onClearPhoto: @escaping () -> Void) {
        
        _localImage = localImage
        self.imageUrl = imageUrl
        self.placeholderImageName = placeholderImageName
        self.size = size
        self.isEditButtonShowing = isEditButtonShowing
        self.onClearPhoto = onClearPhoto 
    }
    

    var body: some View {
        ZStack {
            if let localImage = localImage {
                Image(uiImage: localImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ClientAsyncImage(placeholderImageName: placeholderImageName, imageUrl: imageUrl, size: size)
            }
            if isEditButtonShowing{
                EditButton(action: { self.triggerActionSheet() })
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .sheet(isPresented: Binding(get: { pickerState?.showing ?? false }, set: { if !$0 { pickerState = nil } })) {
            if let pickerState = pickerState {
//                ImagePickerController(image: $localImage, sourceType: pickerState.sourceType)
                ImagePickerController(images: Binding(get: { [localImage].compactMap { $0 } }, set: { localImage = $0.first }), sourceType: pickerState.sourceType)


            }
        }
    }

    func triggerActionSheet() {
        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(makeLibraryAction())
        actionSheet.addAction(makeCameraAction())
        actionSheet.addAction(makeClearPhotoAction())
        actionSheet.addAction(makeCancelAction())
        
        presentActionSheet(actionSheet)

    }
    
    func presentActionSheet(_ actionSheet: UIAlertController) {
        if let presenter = UIApplication.shared.windows.first?.rootViewController {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = presenter.view
                popoverController.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            presenter.present(actionSheet, animated: true, completion: nil)
        }
    }


    func makeLibraryAction() -> UIAlertAction {
        UIAlertAction(title: "Add from Library", style: .default, handler: { _ in
            self.pickerState = (showing: true, sourceType: .photoLibrary)
        })
    }

    func makeCameraAction() -> UIAlertAction {
        UIAlertAction(title: "Open Camera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.pickerState = (showing: true, sourceType: .camera)
            } else {
                print("Camera not available")
            }
        })
    }

    func makeClearPhotoAction() -> UIAlertAction {
        UIAlertAction(title: "Clear Photo", style: .destructive, handler: { _ in
            self.onClearPhoto() // calling parent view
        })
    }

    func makeCancelAction() -> UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }

}



struct EditButton: View {
    let action: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Button(action: action) {
                Text("Edit")
                    .frame(maxWidth: .infinity)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.black.opacity(0.7))
            }
        }
    }
}


