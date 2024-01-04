//
//  ClientDetailView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 16/03/2023.
//
import SwiftUI
import Combine


// MARK: - ClientDetail - ViewModel

class ClientDetailViewModel: ObservableObject {
    
    // Adjust this value to represent the desired progress
    @Published var progress: Double = 0.0
    @Published var remainingSessions: Int = 0

    @Published var shouldDismiss = false
     @Published var isShowingForm = false
     @Published var selectedClient: Client

     private let clientsDataStore: ClientsDataStore
     private let categoryDataStore: CategoryDataStore
     let profileImageSize: CGFloat = 150
    

     private var selectedClientCancellable: AnyCancellable?
     private var selectedClientObserver: AnyCancellable?
     private var cancellables = Set<AnyCancellable>()

        
    init(selectedClient: Client,
         clientsDataStore : ClientsDataStore = AppDependencyContainer.shared.clientsDataStore,
         categoryDataStore : CategoryDataStore = AppDependencyContainer.shared.categoryDataStore
        ) {
        self.selectedClient = selectedClient
        self.clientsDataStore = clientsDataStore
        self.categoryDataStore = categoryDataStore
        
        updateProgress()
        // Set up the observer for the selected client
        clientsDataStore.$allClients.sink { [weak self] newClients in
            if let selfClient = self {
                if let updatedClient = newClients.first(where: { $0.id == selfClient.selectedClient.id }) {
                    // Update selectedClient to the client object in newClients that has the same id
                    selfClient.selectedClient = updatedClient
                }
                // If there is no matching client in newClients, keep selectedClient as it is

            }
        }
        .store(in: &cancellables)
    }

    
    private func updateProgress() {
         progress = selectedClient.calculateFinishedPhasesPercentage()
         remainingSessions = selectedClient.getTotalAvailableSessions() - selectedClient.getTotalFinishedSessions()
        
     }
    
    func archiveClient(selectedClient: Client){
        var selectedClient = selectedClient
        selectedClient.categoryIDs = categoryDataStore.getCategoryIDs(subStrings: ["Archived"], section: .client)
        for album in selectedClient.progressAlbums{
            var archivedAlbum = album
            archivedAlbum.categoryIDs = categoryDataStore.getCategoryIDs(subStrings: ["Archived"], section: .progressAlbum)
            selectedClient = selectedClient.updateAlbum(selectedAlbum: archivedAlbum)
        }
        clientsDataStore.updateClient(selectedClient) { result in
            // handle error
        }
    }
    
    func updateClient(editClient: Client){
        self.selectedClient = editClient
        clientsDataStore.updateClient(self.selectedClient) { result in
            // handle error
        }
    }
    
    func deleteClient(){
        clientsDataStore.deleteClient(self.selectedClient) { result in
            // handle error
        }
    }
    
    func getInfoRowItems() -> [InfoRowItem] {

        
        var infoRowItems = [InfoRowItem]()
        let clientCardTitles = ["Trainining style", "Injury", "Health Issues", "Payment Type"]
        let clientCardDescriptions = ["","","",""]
        let clientCardValues = [
            selectedClient.trainingStyle.rawValue,
            selectedClient.injury,
            selectedClient.healthIssues,
            selectedClient.paymentType.rawValue]

        
        for index in 0..<clientCardTitles.count {
            let infoRowItem = InfoRowItem(
                title: clientCardTitles[index],
                value: clientCardValues[index],
                description: clientCardDescriptions[index]
            )
            infoRowItems.append(infoRowItem)
        }
        return infoRowItems
    }
    
}


// MARK: - ClientDetail - View
struct ClientDetailView: View, DetailView {

    @EnvironmentObject private var parentVM: ClientsViewModel
    @StateObject private var vm: ClientDetailViewModel
    
    init(item: IdentifiableItem) {
        let client = item as! Client
        self._vm = StateObject(wrappedValue: ClientDetailViewModel(selectedClient: client))
    }
    
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading){
                
                    ClientTitle(
                        name: vm.selectedClient.title,
                        remainingSessions: $vm.remainingSessions,
                        isActive: true,
                        progress: $vm.progress)
                    
                    ClientPhoto(
                        imageUrl: vm.selectedClient.imageUrl,
                        age: vm.selectedClient.age,
                        height: vm.selectedClient.height,
                        weight: vm.selectedClient.weight,
                        placeholderImageName: vm.selectedClient.placeholderName,
                        gender: vm.selectedClient.gender,
                        imageSize: vm.profileImageSize)
                    
                    Divider()
                    
                    InfoRowView(infoRowItem: vm.getInfoRowItems())
                    
                    GeneralHorizontalListView(title: "Phases", items: vm.selectedClient.phases , titleSize: .medium
                                              ,sizeModel: .large, dataType: .phase)
                    GeneralHorizontalListView(title: "Mezocycles", items: vm.selectedClient.mezocycles, titleSize: .medium, sizeModel: .large, dataType: .mezocycle)
                    GeneralHorizontalListView(title: "Food Protocols", items: vm.selectedClient.foodPlans, titleSize: .medium, sizeModel: .medium, dataType: .foodPlan)
                    GeneralHorizontalListView(title: "Measurements", items: vm.selectedClient.measurements, titleSize: .medium, sizeModel: .medium, dataType: .measurement)
                    GeneralHorizontalListView(title: "Progress Photos", items: vm.selectedClient.progressAlbums, titleSize: .medium, sizeModel: .large, dataType: .progressAlbum)
                    
                }
            }
        }
        .onReceive(vm.$shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
        .navigationTitle(vm.selectedClient.title)
        
        .navigationBarItems(trailing: Button(action: {
            // Empty action, button only used to present ContextMenu
        }, label: {
            Image(systemName: "ellipsis.circle") // This is the "more" button
        }).contextMenu {
            NavigationLink(destination: EditClientView(parentVm: self.vm)) {
                HStack{
                    Text("Edit Client")
                    Spacer()
                    Image(systemName: "slider.horizontal.3")
                }
                
            }
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                vm.archiveClient(selectedClient: vm.selectedClient)
                // Call your function to delete the client here
            }, label: {
                HStack{
                    Text("Archive Client")
                    Spacer()
                    Image(systemName: "archivebox")
                }
                .foregroundColor(.red)
            })
            Button(role: .destructive) {
                presentationMode.wrappedValue.dismiss()
                vm.deleteClient()
                // Call your function to delete the client here
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button(role: .cancel) {
                // Call your function to delete the client here
            } label: {
                Label("Cancel", systemImage: "xmark")
            }
        })

        
        
    }
}




struct ClientTitle: View {
    let name: String
    @Binding var  remainingSessions: Int
    let isActive: Bool
    @Binding var progress: Double

    var body: some View {
        HStack(spacing: 53) {
            Spacer()
            
            VStack(alignment: .trailing, spacing: 10) {
                HStack(spacing: 32) {
                    Text(isActive ? "Active plan" : "Inactive plan")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
                    
                    Text("remaining \(remainingSessions) sessions")
                        .font(.system(size: 13, weight: .regular, design: .default))
                        .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
                }
                .padding(.trailing, 20)
                
                ProgressView(value: progress/100)
                    .progressViewStyle(CustomProgressViewStyle())
                    .frame(width: 450)
                    .padding(.trailing, 20)
            }
        }
    }
}

struct ClientPhoto: View {
    var imageUrl: String?
    var age: String
    var height: String
    var weight: String
    var placeholderImageName: String
    var gender: Gender
    var imageSize: CGFloat

    var body: some View {
        HStack(spacing: 37) {
            
            ClientAsyncImage(placeholderImageName: placeholderImageName, imageUrl: imageUrl, size: imageSize)
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    Text("Gender")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
                    
                    Text("\(gender.rawValue)")
                        .fontWeight(.semibold)
                }
                
                HStack(spacing: 10) {
                    Text("Age")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
                    
                    Text("\(age) years")
                        .fontWeight(.semibold)
                }
                
                HStack(spacing: 10) {
                    Text("Height")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
                    
                    Text("\(height) cm")
                        .fontWeight(.semibold)
                }
                
                HStack(spacing: 10) {
                    Text("Weight")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
                    
                    Text("\(weight) kg")
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(.leading, 16)
//        .frame(width: 913, height: 120)
    }
}


struct CustomProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .frame(height: 4)
                    .foregroundColor(Color(.sRGB, red: 120/255, green: 120/255, blue: 128/255, opacity: 0.2))
                
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * geometry.size.width, height: 4)
                    .foregroundColor(Color(.systemGreen))
            }
        }
    }
}

struct ClientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClientDetailView(item: DataModelMock.clients.first!)
    }
}
