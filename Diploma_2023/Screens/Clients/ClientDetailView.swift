//
//  ClientDetailView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 16/03/2023.
//
import SwiftUI


// MARK: - ClientDetail - ViewModel

class ClientDetailViewModel: ObservableObject {
    
    // Adjust this value to represent the desired progress
    @Published private var progress = 0.65
    
    @Published var isShowingForm = false
    
    var selectedClient: Client
    
    private let clientsDataStore: ClientsDataStore
    private let categoryDataStore: CategoryDataStore
    

    
    // Properties for Client's info row
    let clientCardTitles: [String]
    let clientCardValues: [String]
    let clientCardDescriptions: [String]
    
    
    
    init(selectedClient: Client) {
        self.selectedClient = selectedClient
        self.clientsDataStore = AppDependencyContainer.shared.clientsDataStore
        self.categoryDataStore = AppDependencyContainer.shared.categoryDataStore
        
        // UI Properties for Client's info row
        clientCardTitles = ["Trainining style", "Injury", "Health Issues", "Payment Type"]
        clientCardValues = [selectedClient.trainingStyle.rawValue, selectedClient.injury ?? "None", selectedClient.healthIssues ?? "None", selectedClient.paymentType.rawValue]
        clientCardDescriptions = ["","","",""]
    }
    
    func archiveClient(){
        self.selectedClient.categoryIDs = categoryDataStore.getCategoryIDs(subString: "Archived", section: .client)
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
    
    
}


// MARK: - ClientDetail - View
struct ClientDetailView: View, DetailView {

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
                        isActive: true)
                    
                    ClientPhoto(
                        imageUrl: vm.selectedClient.imageName,
                        age: vm.selectedClient.age,
                        height: vm.selectedClient.height,
                        weight: vm.selectedClient.weight)
                    
                    Divider()
                    
                    InfoRowView(cardTitles: vm.clientCardTitles,
                                cardValues: vm.clientCardValues,
                                cardDescriptions: vm.clientCardDescriptions)
                    
                    GeneralHorizontalListView(title: "Phases", items: DataModelMock.trainingProtocols , titleSize: .medium
                                              ,sizeModel: .large, dataType: .phase)
                    GeneralHorizontalListView(title: "Measurements", items: DataModelMock.measurements, titleSize: .medium, sizeModel: .medium, dataType: .measurement)
                    GeneralHorizontalListView(title: "Food Protocols", items: DataModelMock.foodPlans, titleSize: .medium, sizeModel: .medium, dataType: .foodPlan)
                    GeneralHorizontalListView(title: "Mezocycles", items: DataModelMock.mezocycles, titleSize: .medium, sizeModel: .large, dataType: .mezocycle)
                    GeneralHorizontalListView(title: "Progress Photos", items: DataModelMock.progressPhotos, titleSize: .medium, sizeModel: .medium, dataType: .progressAlbum)
                    
                }
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
                    Image(systemName: "pencil")
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

    @State private var progress = 0.65 // Adjust this value to represent the desired progress

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
