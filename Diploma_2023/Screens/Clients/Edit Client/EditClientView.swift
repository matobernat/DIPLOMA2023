//
//  EditClientView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/04/2023.
//

import SwiftUI
import Combine

// MARK: - EditClient - ViewModel
class EditClientViewModel: ObservableObject {
    
    @Published var editClient: Client
    @Published var newProfileImage: UIImage? = nil
    @Published var currentEditClientImageUrl: String? = nil
    
    private let imageRepository: ImageRepository
    private let clientsDataStore: ClientsDataStore
    var cancellables = Set<AnyCancellable>()

    init(selectedClient: Client,
         imageRepository: ImageRepository = AppDependencyContainer.shared.imageRepository,
         clientsDataStore: ClientsDataStore = AppDependencyContainer.shared.clientsDataStore
        ){
        // duplicate selectedClient
        self.editClient = selectedClient
        self.imageRepository = imageRepository
        self.clientsDataStore = clientsDataStore
        self.currentEditClientImageUrl = editClient.imageUrl

    }
    
    
    func saveChanges(completion: @escaping (Result<Void, Error>) -> ()) {
        if let newImage = self.newProfileImage {
            print("SAVING NEW IMAGE")
            imageRepository.updateImage(oldUrl: self.editClient.imageUrl, newImage: newImage) { result in
                switch result {
                case .failure(let error):
                    print("Failed to upload image: \(error)")
                    completion(.failure(error))
                case .success(let newUrl):
                    print("Image upload finished")
                    DispatchQueue.main.async {
                        self.editClient.imageUrl = newUrl
                        self.updateClient(client: self.editClient, completion: completion)
                    }
                }
            }
        } else if currentEditClientImageUrl == nil{
            print("DELETING IAMGEEEEEE")
            self.deletePhoto()
            self.updateClient(client:  self.editClient, completion: completion)
        }
        else{
            print("UPDATE CLIEEEENT")
            self.updateClient(client: self.editClient, completion: completion)
        }
    }


    func clearPhoto(){
        if self.newProfileImage == nil{
            self.currentEditClientImageUrl = nil
        }
        else{
            self.newProfileImage = nil
        }
    }
    
    func deletePhoto() {
        imageRepository.deleteImage(url: self.editClient.imageUrl) { result in
            switch result {
            case .failure(let error):
                print("deletePhoto() Failed to delete image: \(error)")
            case .success():
                print("Image deleted.")
            }
            DispatchQueue.main.async {
                self.editClient.imageUrl = nil
                self.clientsDataStore.clearClientImageUrl(clientId: self.editClient.id) { result in
                    switch result {
                    case .failure(let error):
                        print("Failed to clear ImageUrl: \(error)")
                    case .success():
                        print("cleared")
                    }
                }
            }
        }
    }

    
    func updateClient(client: Client, completion: @escaping (Result<Void, Error>) -> ()) {
        clientsDataStore.updateClient(client) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
        
        
        
// MARK: - EditClient - View

    struct EditClientView: View {
        
        @Environment(\.presentationMode) var presentationMode
        @State private var showErrorAlert = false
        @State private var error: Error? = nil
        
        
        @ObservedObject var parentVm: ClientDetailViewModel
        @ObservedObject var vm: EditClientViewModel

        
        init(parentVm: ClientDetailViewModel) {
            self.parentVm = parentVm
            self.vm = EditClientViewModel(selectedClient: parentVm.selectedClient)
        }
        
        
        var body: some View {
            
                Form {
                    
                    Section {
                        EditProfileImageView(
                            localImage: $vm.newProfileImage,
                            imageUrl: vm.currentEditClientImageUrl,
                            placeholderImageName: vm.editClient.placeholderName,
                            size: 160,
                            onClearPhoto: {
                                vm.clearPhoto()
                            }
                        )
                    }
                    .listRowBackground(Color.clear)
                    
                    
                    Section(header: Text("Contact Information")) {
                        TextField("First Name", text: $vm.editClient.firstName)
                        TextField("Last Name", text: $vm.editClient.lastName)
                        
                        Picker("Gender", selection: $vm.editClient.gender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue)
                            }
                        }
                        
                        TextField("Email", text: $vm.editClient.email)
                            .keyboardType(.emailAddress)
                        TextField("Phone Number", text: $vm.editClient.phone)
                            .keyboardType(.numberPad)
                            .onReceive(Just(vm.editClient.phone)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    vm.editClient.phone = filtered
                                }
                            }
                    }
                    
                    Section(header: Text("Health Information")) {
                        TextField("Age", text: $vm.editClient.age)
                            .keyboardType(.numberPad)
                        TextField("Weight", text: $vm.editClient.weight)
                            .keyboardType(.numberPad)
                        TextField("Height", text: $vm.editClient.height)
                            .keyboardType(.numberPad)
                        TextField("Injury", text: $vm.editClient.injury)
                        TextField("Health Issues", text: $vm.editClient.healthIssues)
                    }
                    
                    Section(header: Text("Additional Information")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Active", isOn: $vm.editClient.active)
                            Text("Active user is the one that will be training in the near future")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Picker("Training Style", selection: $vm.editClient.trainingStyle) {
                            ForEach(TrainingStyle.allCases, id: \.id) { style in
                                Text(style.rawValue)
                                    .tag(style)
                            }
                        }
                    }
                    
                    Section(header: Text("Other Information")) {
                        Picker("Payment Type", selection: $vm.editClient.paymentType) {
                            ForEach(PaymentType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                    }
                    
                    
                }

                .navigationBarTitle(Text("Edit Client"))
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: {
                        print("cancel")
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text("Cancel")
                    },
                    trailing: Button(action: {
                        // Save the changes and dismiss the view
                        vm.saveChanges { result in
                            switch result {
                            case .success:
                                parentVm.selectedClient = vm.editClient
                                presentationMode.wrappedValue.dismiss()
                            case .failure(let error):
                                self.error = error
                                showErrorAlert = true
                            }
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }
                )
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"),
                          message: Text(error?.localizedDescription ?? "Unknown error"),
                          dismissButton: .default(Text("OK")))
                }
                
            }
    }

