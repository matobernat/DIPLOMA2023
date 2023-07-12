//
//  NewAlbumView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 05/07/2023.
//

import SwiftUI
import Combine

// MARK: - NewProgressAlbum - ViewModel
class NewAlbumViewModel: ObservableObject {



//    @Published var selectedProgressAlbum: ProgressAlbum?
    @Published var selectedClient: Client?
    @Published var selectedCategory: Category
    @Published var pickedImages: [UIImage] = []
    @Published var albumTitle: String = ""
    @Published var albumSubtitle: String = ""
    
    
    @Published var clientItems: [(Client, title: String, imageUrl: String?, placeholderName: String?)] = []
    @Published private(set) var clients: [Client] = []
    private var cancellables = Set<AnyCancellable>()
    private let clientsDataStore: ClientsDataStore
    private let categoryDataStore: CategoryDataStore
    private let imageRepository: ImageRepository
    
    
    
    init(
        
        selectedCategory: Category,
        
        clientsDataStore: ClientsDataStore = AppDependencyContainer.shared.clientsDataStore,
        categoryDataStore: CategoryDataStore = AppDependencyContainer.shared.categoryDataStore,
        imageRepository: ImageRepository = AppDependencyContainer.shared.imageRepository
    ) {
        
        self.clientsDataStore = clientsDataStore
        self.categoryDataStore = categoryDataStore
        self.imageRepository = imageRepository
        
//        self.selectedProgressAlbum = selectedProgressAlbum
        self.selectedCategory = selectedCategory
//        self.clients = clientsDataStore.allClients
        
        
        // Subscribe to changes in allClients
        self.clientsDataStore.$allClients.sink { [weak self] newClients in
            self?.clients = newClients
            // Transform newClients into clientItems
            self?.clientItems = newClients.map { ($0, $0.title, $0.imageUrl, $0.placeholderName) }
        }
        .store(in: &cancellables)
        
        
        
    }
    
    
    func onSave(selectedClient: Client, title: String, subtitle: String, selectedCategory: Category, pickedImages: [UIImage]){
        
        var progressPhotos: [ProgressPhoto] = []
        
        let group = DispatchGroup()

        for image in pickedImages {
            group.enter()
            imageRepository.uploadImage(image) { result in
                switch result {
                case .success(let imageUrl):
                    print("\n \n IMAGE UPLOAD SUCCESSFULL")
                    let progressPhoto = ProgressPhoto(id: UUID().uuidString, imageUrl: imageUrl, dateOfCreation: Date())
                    progressPhotos.append(progressPhoto)
                case .failure(let error):
                    print("\n \n IMAGE UPLOAD FAILED")
                    print("Image upload failed: \(error)")
                }
                group.leave()
            }
        }
        

        
        var categoryIDs = categoryDataStore.getCategoryIDs(selectedCategory: selectedCategory)
        
        group.notify(queue: .main) {
            var newProgressAlbum = ProgressAlbum(
                title: title,
                subTitle: subtitle,
                categoryIDs: categoryIDs,
                accountID: selectedClient.accountID,
                clientID: selectedClient.id,
                profileID: selectedClient.profileID,
                dateOfCreation: Date(),
                dateLastModification: Date(),
                progressPhotos: progressPhotos
            )
        
            self.clientsDataStore.updateProgressAlbum(progressAlbum: newProgressAlbum) { result in
                switch result {
                case .success:
                    print("Progress album successfully updated")
                case .failure(let error):
                    print("Failed to update progress album: \(error)")
                }
            }
        }
        
    }
    
    
}

// MARK: - NewProgressAlbum - View
struct NewAlbumView: View {
    
    var selectedCategory: Category
    
    @ObservedObject private var vm: NewAlbumViewModel



    
    
    init(selectedCategory: Category) {
        self.selectedCategory = selectedCategory
        self.vm = NewAlbumViewModel(selectedCategory: selectedCategory)
    }
    
//    @State private var selectedClient: String = ""
//    @State private var title: String = ""
//    @State private var subTitle: String = ""
    
    @State private var showingSelectableList = false
    @State private var showingImagePicker = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20){
                    HeaderView(showingSelectableList: $showingSelectableList,
                               selectedClient: $vm.selectedClient,
                               subTitle: $vm.albumSubtitle)

//                    ImageListView(showingImagePicker: $showingImagePicker,
//                                  pickedImages: $vm.pickedImages)
                    AddImagesListView(pickedImages: $vm.pickedImages)
                }
            }

            .navigationTitle("New Progress Album")
            .sheet(isPresented: $showingImagePicker) {
                Text("Image Picker")
            }
            .sheet(isPresented: $showingSelectableList) {
                SelectableListView(
                    items: vm.clientItems,
                    multipleSelection: false,
                    selectSfSymbolName: "plus.circle",
                    unselectSfSymbolName: "minus",
                    selectedItems: vm.selectedClient != nil ? [vm.selectedClient!] : [],
                    onDone: { selectedItems in
                        // Use selectedItems as you need.
                        vm.selectedClient = selectedItems.first
                        self.showingSelectableList = false
                    }, onCancel: {
                        self.showingSelectableList = false
                    }
                )
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        print("CANCEL")
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("SAVE")
                        if let selectedClient = vm.selectedClient{
                            presentationMode.wrappedValue.dismiss()
                            vm.onSave(selectedClient: selectedClient,
                                      title: "\(selectedClient.title)'s Album",
                                      subtitle: vm.albumSubtitle,
                                      selectedCategory: vm.selectedCategory,
                                      pickedImages: vm.pickedImages)
                        }
                        
                    }) {
                        Text("Save")
                    }
                }
            }
            
        }
    }
}


struct HeaderView: View {
    @Binding var showingSelectableList: Bool
    @Binding var selectedClient: Client?
    @Binding var subTitle: String

    var body: some View {
        HStack{
            // Thumbnail + Edit button
            VStack {
                if let client = selectedClient {
                    ClientAsyncImage(placeholderImageName: client.placeholderName, imageUrl: client.imageUrl, size: 100)
                        .onTapGesture {
                            self.showingSelectableList.toggle()
                        }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            self.showingSelectableList.toggle()
                        }
                }

                Button(action: {
                    self.showingSelectableList.toggle()
                }) {
                    Text("Edit")
                        .font(.caption)
                }
                .padding(.top, 5)
            }
            .padding(10)
            .padding(.leading, 30)
            .padding(.trailing, 40)
            
            VStack{
                HStack{
                    Text("Title:")
                        .font(.title2)
                        .padding(.trailing, 20)

                    if let title = selectedClient?.title{
                        Text("\(title)'s Album")
                            .onTapGesture {
                                self.showingSelectableList.toggle()
                            }
                            .font(.largeTitle)
                    }else{
                        Text("No client selected..")
                            .onTapGesture {
                                self.showingSelectableList.toggle()
                            }
                            .font(.title3)
                            .foregroundStyle(.foreground.opacity(0.2))
                    }

                    Spacer()
                }
                
                HStack{
                    Text("Subtitle:")
                        .font(.title2)
                        .padding(.trailing, 20)

                    TextField("Sub Title", text: $subTitle)
                        .font(.system(size: 20))
                        .frame(width: 300)
                        .padding(5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}


struct AddImagesListView: View {
    @Binding var pickedImages: [UIImage]

    var body: some View {
        Text("AddImagesListView")
//        ClientImagePickerView(images: $pickedImages) { images, triggerImagePicker in
//            VStack(alignment: .leading){
//                Text("Photos")
//                    .font(.title)
//                HStack {
//                    LargeCardButtonLabel(type: .progressAlbum)
//                        .onTapGesture {
//                            triggerImagePicker()
//                        }
//
//                    ForEach(images.wrappedValue, id: \.self) { image in
//                        Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 160, height: 160)
//                    }
//                }
//            }
//            .padding()
//        }
    }
}

