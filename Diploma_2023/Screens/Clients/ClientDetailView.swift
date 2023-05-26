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

    @Published var shouldDismiss = false
     @Published var isShowingForm = false
     @Published var selectedClient: Client

     private let clientsDataStore: ClientsDataStore
     private let categoryDataStore: CategoryDataStore

     private var selectedClientCancellable: AnyCancellable?
     private var selectedClientObserver: AnyCancellable?
     private var cancellables = Set<AnyCancellable>()

        
    init(selectedClient: Client) {
        self.selectedClient = selectedClient
        self.clientsDataStore = AppDependencyContainer.shared.clientsDataStore
        self.categoryDataStore = AppDependencyContainer.shared.categoryDataStore
        
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
     }
    
    
    
    func archiveClient(){
        self.selectedClient.categoryIDs = categoryDataStore.getCategoryIDs(subStrings: ["Archived"], section: .client)
        clientsDataStore.updateClient(self.selectedClient) { result in
            // handle error
        }
    }
    
    func updateClient(){
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
                        remainingSessions: 3,
                        isActive: true,
                        progress: $vm.progress)
                    
                    ClientPhoto(
                        imageUrl: vm.selectedClient.imageName,
                        age: vm.selectedClient.age,
                        height: vm.selectedClient.height,
                        weight: vm.selectedClient.weight)
                    
                    Divider()
                    
                    InfoRowView(infoRowItem: vm.getInfoRowItems())
                    
                    GeneralHorizontalListView(title: "Phases", items: vm.selectedClient.phases , titleSize: .medium
                                              ,sizeModel: .large, dataType: .phase)
                    GeneralHorizontalListView(title: "Measurements", items: DataModelMock.measurements, titleSize: .medium, sizeModel: .medium, dataType: .measurement)
                    GeneralHorizontalListView(title: "Food Protocols", items: DataModelMock.foodPlans, titleSize: .medium, sizeModel: .medium, dataType: .foodPlan)
                    GeneralHorizontalListView(title: "Mezocycles", items: vm.selectedClient.mezocycles, titleSize: .medium, sizeModel: .large, dataType: .mezocycle)
                    GeneralHorizontalListView(title: "Progress Photos", items: DataModelMock.progressPhotos, titleSize: .medium, sizeModel: .medium, dataType: .progressAlbum)
                    
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
                vm.archiveClient()
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
    let remainingSessions: Int
    let isActive: Bool
    @Binding var progress: Double

//    @State private var progress = 0.65 // Adjust this value to represent the desired progress

    var body: some View {
        HStack(spacing: 53) {
//            Text(name)
//                .font(.system(size: 34, weight: .bold, design: .default))
//                .lineLimit(1)
//                .foregroundColor(Color.black)
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
                
                ProgressView(value: progress)
                    .progressViewStyle(CustomProgressViewStyle())
                    .frame(width: 450)
                    .padding(.trailing, 20)
            }
        }
//        .padding(.leading, 16)
    }
}

struct ClientPhoto: View {
    var imageUrl: String
    var age: String
    var height: String
    var weight: String

    var body: some View {
        HStack(spacing: 37) {
            if let imageURL = URL(string: "") {
                RoundedRectangle(cornerRadius: 60)
                    .fill(Color(.sRGB, red: 217/255, green: 217/255, blue: 217/255, opacity: 1))
                    .overlay(
                        AsyncImage(url: imageURL) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                    )
                    .frame(width: 120, height: 120)
            } else {
                Image(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
//                RoundedRectangle(cornerRadius: 60)
//                    .fill(Color(.sRGB, red: 217/255, green: 217/255, blue: 217/255, opacity: 1))
//                    .frame(width: 120, height: 120)
            }
            
            VStack(alignment: .leading, spacing: 10) {
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
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 2)
                .frame(height: 4)
                .foregroundColor(Color(.sRGB, red: 120/255, green: 120/255, blue: 128/255, opacity: 0.2))
            
            RoundedRectangle(cornerRadius: 2)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 224, height: 4)
                .foregroundColor(Color(.systemGreen))
        }
    }
}

struct ClientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClientDetailView(item: DataModelMock.clients.first!)
    }
}
