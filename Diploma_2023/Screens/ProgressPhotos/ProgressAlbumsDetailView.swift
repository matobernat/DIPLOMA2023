//
//  ProgressAlbumsDetail.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 09/07/2023.
//

import SwiftUI
import Combine


class ProgressAlbumsDetailViewModel: ObservableObject {
    
    @Published var selectedProgressAlbum: ProgressAlbum
    @Published var pickedImages: [UIImage] = []
    @Published var progressPhotoURLs: [URL: Date] = [:]
    
    
    // Local
    private let clientsDataStore: ClientsDataStore
    private let categoryDataStore: CategoryDataStore
    private let imageRepository : ImageRepository
    private var cancellables = Set<AnyCancellable>()
    
    
    init(
        selectedProgressAlbum: ProgressAlbum,
        
        clientsDataStore: ClientsDataStore = AppDependencyContainer.shared.clientsDataStore,
        categoryDataStore: CategoryDataStore = AppDependencyContainer.shared.categoryDataStore,
        imageRepository : ImageRepository = AppDependencyContainer.shared.imageRepository
        
        
        
    ){
        self.selectedProgressAlbum = selectedProgressAlbum
        self.clientsDataStore = clientsDataStore
        self.categoryDataStore = categoryDataStore
        self.imageRepository = imageRepository
        
        
//         Create a derived publisher that transforms `selectedProgressAlbum.progressPhotos` into URLs
        $selectedProgressAlbum
            .map { progressAlbum in
                var urlDatePairs: [URL: Date] = [:]
                for progressPhoto in progressAlbum.progressPhotos {
                    if let url = URL(string: progressPhoto.imageUrl) {
                        urlDatePairs[url] = progressPhoto.dateOfCreation // Assuming `date` is a property of ProgressPhoto
                    }
                }
                return urlDatePairs
            }
            .assign(to: \.progressPhotoURLs, on: self)
            .store(in: &cancellables)

        
    }

    func archiveAlbum(selectedAlbum: ProgressAlbum){

        var selectedAlbum = selectedAlbum
        selectedAlbum.categoryIDs = categoryDataStore.getCategoryIDs(subStrings: ["Archived"], section: .progressAlbum)

        if var selectedClient = clientsDataStore.getClient(clientID: self.selectedProgressAlbum.clientID){
            selectedClient = selectedClient.updateAlbum(selectedAlbum: selectedAlbum)
            clientsDataStore.updateClient(selectedClient) { result in
                // handle error

            }
        }
    }

    func addImage(selectedImage: UIImage){

        // Upload the image
        imageRepository.uploadImage(selectedImage) { result in
            switch result {
            case .success(let imageUrl):
                
                // Add the image URL to the progress album
                self.selectedProgressAlbum.progressPhotos.append(ProgressPhoto(imageUrl: imageUrl))
                
                self.updateAlbum(selectedAlbum: self.selectedProgressAlbum)
                
            case .failure(let error):
                print("Failed to upload image: \(error)")
                // You could also remove the model from the array or set isLoading to false so the user can try again
            }
        }

    }


    func updateAlbum(selectedAlbum: ProgressAlbum){
        if var selectedClient = clientsDataStore.getClient(clientID: self.selectedProgressAlbum.clientID){
            selectedClient = selectedClient.updateAlbum(selectedAlbum: self.selectedProgressAlbum)
            clientsDataStore.updateClient(selectedClient) { result in
                // handle error
            }
        }
    }

    func deleteAlbum(selectedAlbum: ProgressAlbum){
        if var selectedClient = clientsDataStore.getClient(clientID: self.selectedProgressAlbum.clientID){
            selectedClient = selectedClient.deleteAlbum(selectedAlbumId: selectedAlbum.id)
            clientsDataStore.updateClient(selectedClient) { result in
                // handle error
            }
        }
    }


}


struct ProgressAlbumsDetail: View, DetailView  {

//    var selectedProgressAlbum: IdentifiableItem

    @ObservedObject private var vm: ProgressAlbumsDetailViewModel





    init(item: IdentifiableItem) {
        self.vm = ProgressAlbumsDetailViewModel(selectedProgressAlbum: item as! ProgressAlbum)
    }



    @State private var showingSelectableList = false
    @State private var showingImagePicker = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20){
                    HStack{
                        AsyncImageListView(pickedImageURLs: $vm.progressPhotoURLs, parentViewModel: vm, addImage: vm.addImage )
                        Spacer()
                    }
                }


            }

            .navigationTitle(vm.selectedProgressAlbum.title)
            .sheet(isPresented: $showingImagePicker) {
                Text("Image Picker")
            }
            .navigationBarItems(trailing: Button(action: {
                // Empty action, button only used to present ContextMenu
            }, label: {
                Image(systemName: "ellipsis.circle") // This is the "more" button
            }).contextMenu {
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    vm.archiveAlbum(selectedAlbum: vm.selectedProgressAlbum)
                    // Call your function to delete the client here
                }, label: {
                    HStack{
                        Text("Archive Album")
                        Spacer()
                        Image(systemName: "archivebox")
                    }
                    .foregroundColor(.red)
                })
                Button(role: .destructive) {
                    presentationMode.wrappedValue.dismiss()
                    vm.deleteAlbum(selectedAlbum: vm.selectedProgressAlbum)
                    // Call your function to delete the client here
                } label: {
                    Label("Delete Album", systemImage: "trash")
                }
                Button(role: .cancel) {
                    // Call your function to delete the client here
                } label: {
                    Label("Cancel", systemImage: "xmark")
                }
            })


            }

        }

}


struct AsyncImageListView: View {
    @Binding var pickedImageURLs: [URL: Date]
    @ObservedObject var parentViewModel: ProgressAlbumsDetailViewModel
    let addImage: (UIImage) -> Void

    var gridLayout: [GridItem] = [
        GridItem(.adaptive(minimum: 160))
    ]

    var body: some View {
        ImagePickerBaseView(onImagePicked: addImage) { triggerImagePicker in
            VStack(alignment: .leading){
                Text("Photos")
                    .font(.title)
                LazyVGrid(columns: gridLayout, spacing: 5) {
                    LargeCardButtonLabel(type: .progressAlbum)
                        .onTapGesture {
                            triggerImagePicker()
                        }
                     ForEach(pickedImageURLs.sorted(by: { $0.value < $1.value }), id: \.key) { url, date in
                        if let index = parentViewModel.selectedProgressAlbum.progressPhotos.firstIndex(where: { $0.imageUrl == url.absoluteString }) {
                            NavigationLink(destination: ProgressPhotoDetailView(progressPhotos: parentViewModel.selectedProgressAlbum.progressPhotos, selectedProgressPhotoIndex: .constant(index), parentViewModel: parentViewModel)) {
                                VStack {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image.resizable().aspectRatio(contentMode: .fill)
                                        case .failure:
                                            Image(systemName: "photo")
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .frame(width: 160, height: 160)
                                    .clipped()

                                    Text("\(date.ISO8601Format())")
                                        .font(.caption2)
                                    // Display the date below the image. You'll need to implement `DateFormatter.shortDate` or use your preferred date format.
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct AsyncImageListViewOld: View {
    @Binding var pickedImageURLs: [URL: Date]
    let addImage: (UIImage) -> Void

    // Define the layout of your grid
    var gridLayout: [GridItem] = [
        GridItem(.adaptive(minimum: 160)) // This creates as many 160pt-wide columns as will fit in the space
    ]

    var body: some View {
        ImagePickerBaseView(onImagePicked: addImage) { triggerImagePicker in
            VStack(alignment: .leading){
                Text("Photos")
                    .font(.title)
                
                // Use the grid layout
                LazyVGrid(columns: gridLayout, spacing: 5) {
                    
                    LargeCardButtonLabel(type: .progressAlbum)
                        .onTapGesture {
                            triggerImagePicker()
                        }
                    ForEach(pickedImageURLs.sorted(by: { $0.value < $1.value }), id: \.key) { url, date in
                                           VStack {
                                               AsyncImage(url: url) { phase in
                                                   switch phase {
                                                   case .empty:
                                                       ProgressView()
                                                   case .success(let image):
                                                       image.resizable().aspectRatio(contentMode: .fill)
                                                   case .failure:
                                                       Image(systemName: "photo")
                                                   @unknown default:
                                                       EmptyView()
                                                   }
                                               }
                                               .frame(width: 160, height: 160)
                                               .clipped()

                                               Text("\(date.ISO8601Format())")
                                                   .font(.caption2)
                                               // Display the date below the image. You'll need to implement `DateFormatter.shortDate` or use your preferred date format.
                                           }
                                       }
                                   }
                               }
                               .padding()
                           }
                       }
                   }



//struct AsyncImageListViewOld: View {
//    @Binding var pickedImageURLs: [URL: Date]
//    let addImage: (UIImage) -> Void
//
//    // Define the layout of your grid
//    var gridLayout: [GridItem] = [
//        GridItem(.adaptive(minimum: 160)) // This creates as many 160pt-wide columns as will fit in the space
//    ]
//
//    var body: some View {
//        ImagePickerBaseView(onImagePicked: addImage) { triggerImagePicker in
//            VStack(alignment: .leading){
//                Text("Photos")
//                    .font(.title)
//
//                // Use the grid layout
//                LazyVGrid(columns: gridLayout, spacing: 5) {
//
//                    LargeCardButtonLabel(type: .progressAlbum, title: "New Photo")
//                        .onTapGesture {
//                            triggerImagePicker()
//                        }
//                    ForEach(pickedImageURLs.sorted(by: { $0.value < $1.value }), id: \.key) { url, date in
//                        let index = pickedImageURLs.keys.sorted().firstIndex(of: url) ?? 0
//                        NavigationLink(destination: ProgressPhotoDetailView(urls: Array(pickedImageURLs.keys), selectedIndex: index)) {
//                            VStack {
//                                AsyncImage(url: url) { phase in
//                                    switch phase {
//                                    case .empty:
//                                        ProgressView()
//                                    case .success(let image):
//                                        image.resizable().aspectRatio(contentMode: .fill)
//                                    case .failure:
//                                        Image(systemName: "photo")
//                                    @unknown default:
//                                        EmptyView()
//                                    }
//                                }
//                                .frame(width: 160, height: 160)
//                                .clipped()
//
//                                Text("\(date.ISO8601Format())")
//                                    .font(.caption2)
//                                // Display the date below the image. You'll need to implement `DateFormatter.shortDate` or use your preferred date format.
//                            }
//                        }
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//}


