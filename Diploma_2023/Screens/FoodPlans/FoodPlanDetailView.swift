//
//  FoodPlanView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 31/10/2023.
//

import SwiftUI
import Combine

// MARK: - FoodPlan - ViewModel
class FoodPlanDetailViewModel: ObservableObject {
    
    @Published var selectedFoodPlan: FoodPlan
    @Published var selectedFoodPlanDataConverted: [UnifiedPage] = []
    @Published var dataWasChanged = false
    @Published var isEditing = false
    @Published var showSavedMessage: Bool = false
    @Published var isShowingSelectableClientList: Bool = false
    
    // FoodPlans
    private let foodPlansDataStore: FoodPlansDataStore
    @Published private(set) var foodPlans: [FoodPlan] = []
    
    
    
    // Clients
    private let clientsDataStore: ClientsDataStore
    @Published private(set) var clients: [Client] = []
    @Published var clientItems: [(Client, title: String, imageUrl: String?, placeholderName: String?)] = []
    
    
    
    private var cancellables = Set<AnyCancellable>()

    
    
    init(
        selectedFoodPlan: FoodPlan,
        dataWasChanged: Bool = false,
        isEditing: Bool = false,
        showSavedMessage: Bool = false,
        foodPlansDataStore: FoodPlansDataStore = AppDependencyContainer.shared.foodPlansDataStore,
        clientsDataStore: ClientsDataStore = AppDependencyContainer.shared.clientsDataStore
    ) {
        
        self.selectedFoodPlan = selectedFoodPlan
        self.dataWasChanged = dataWasChanged
        self.isEditing = isEditing
        self.showSavedMessage = showSavedMessage
        
        
        //  Data Stores
        self.clientsDataStore = clientsDataStore
        self.foodPlansDataStore = foodPlansDataStore
        
        self.selectedFoodPlanDataConverted = processFoodPlanData(data: selectedFoodPlan.inputData)
        

        
        
        // Clients fetching
        self.clientsDataStore.$allClients.sink { [weak self] newClients in
            self?.clients = newClients
            // Transform newClients into clientItems
            self?.clientItems = newClients.map { ($0, $0.title, $0.imageUrl, $0.placeholderName) }
        }
        .store(in: &cancellables)
    }
    
    
    func updateFoodPlan(selectedItem: FoodPlan, inputData: [UnifiedPage]){
        

        // UI --> JSON
        let convertedJSON = backToOriginalFormat(pages: inputData)
        
        foodPlansDataStore.createAndRetrieveDocument(
            withPayload:  FoodPlan.convertFoodPlanDataToJSONString(convertedJSON)! ,
            //update foodPlan.JSON
            forFoodPlan: selectedFoodPlan.setFoodPlanData(inputData: convertedJSON)) { result in
                switch result{
                case .success(let firebaseURL):
                    self.selectedFoodPlan.firestoreDownloadURL = firebaseURL
                case .failure(let error):
                    print("Updateing error")
                }
            }
    }
    
    func duplicatePlan(selectedItem: FoodPlan){
        
        // duplicating template
        if selectedItem.clientID == nil{
            foodPlansDataStore.createFoodPlan(selectedItem.duplicate()) { result in
                print("foodPlan template was duplicated")
            }
        }
        // duplicating client's plan
        else{
            if var selectedClient = clientsDataStore.getClient(clientID: selectedItem.clientID){
                
                clientsDataStore.updateClient(selectedClient.addFoodPlan(selectedItem: selectedItem.duplicate())) { result in
                    print("client's foodPlan was duplicated")
                }
            }
            

        }

    }
    
    func associateWithClient(selectedItem: FoodPlan, withClient: Client){
        
        clientsDataStore.updateClient(withClient.addFoodPlan(selectedItem: selectedItem.associateWithClient(clientID: withClient.id))) { results in
            print("FoodProtocol associated with Client")
        }
        
    }
    func deletePlan(selectedItem: FoodPlan){
        // delete template
        if selectedItem.clientID == nil{
            foodPlansDataStore.deleteFoodPlan(selectedItem) { result in
                print("foodPlan template was duplicated")
            }
        }
        // delete client's plan
        else{
            if var selectedClient = clientsDataStore.getClient(clientID: selectedItem.clientID){
                
                clientsDataStore.updateClient(selectedClient.deleteFoodPlan(selectedItemId: selectedItem.id)) { result in
                    print("client's foodPlan was duplicated")
                }
            }
            

        }
    }
    
    
}
    



// MARK: - FoodPlanDetail - View

struct FoodPlanDetailView: View, DetailView {
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var vm: FoodPlanDetailViewModel


    init(item: IdentifiableItem) {
        
        self.vm = FoodPlanDetailViewModel(selectedFoodPlan: item as! FoodPlan)
    }
            
        
    var body: some View {
        NavigationStack{
//        ScrollView{
//            Text("\(vm.selectedFoodPlan.status?.rawValue ?? "default value")")
            PDFContentView(status: $vm.selectedFoodPlan.status ,firebaseURL: $vm.selectedFoodPlan.firestoreDownloadURL)
            
        }
        .navigationTitle(vm.selectedFoodPlan.title)
        .navigationBarItems(trailing: Button(action: {
            // Empty action, button only used to present ContextMenu
        }, label: {
            Image(systemName: "ellipsis.circle") // This is the "more" button
        }).contextMenu
                            {
            
            Button(action: {
                //addMezoToClientSheet()
//                presentationMode.wrappedValue.dismiss()
//                vm.isShowingSheetList = true
//                vm.isShowingSheet = true
                vm.isShowingSelectableClientList = true
                // Call your function to delete the client here
            }, label: {
                HStack{
                    Text("Add to client")
                    Spacer()
                    Image(systemName: "person.badge.plus")
                }
                .foregroundColor(.red)
            })
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                vm.duplicatePlan(selectedItem: vm.selectedFoodPlan)
                // Call your function to delete the client here
            }, label: {
                HStack{
                    Text("Duplicate FoodPlan")
                    Spacer()
                    Image(systemName: "doc.on.doc")
                }
                .foregroundColor(.red)
            })
            if vm.selectedFoodPlan.clientID == nil {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
//                    vm.archiveMezo(selectedMezo: vm.selectedMezo)
                    // Call your function to delete the client here
                }, label: {
                    HStack{
                        Text("Archive FoodPlan")
                        Spacer()
                        Image(systemName: "archivebox")
                    }
                    .foregroundColor(.red)
                })
            }
            
            Button(role: .destructive) {
                presentationMode.wrappedValue.dismiss()
//                vm.deleteMezo(selectedMezo: vm.selectedMezo)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditFoodPlanView(parentVm: self.vm)) {
                    HStack{
                        Text("Edit")
                    }
                    
                }
            }
        }
        .sheet(isPresented: $vm.isShowingSelectableClientList) {
            SelectableListView(
                items: vm.clientItems,
                multipleSelection: false,
                selectSfSymbolName: "plus.circle",
                unselectSfSymbolName: "minus",
                selectedItems: [],
                onDone: { selectedItems in
                    // Use selectedItems as you need.
                    if let selectedItem = selectedItems.first {
                        vm.associateWithClient(selectedItem: vm.selectedFoodPlan, withClient: selectedItem)
                        vm.isShowingSelectableClientList = false
//                        vm.isShowingForm = true
                        print(selectedItems.first?.title)

                    }
                }, onCancel: {
                    vm.isShowingSelectableClientList = false
                }
            )
        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                if vm.isEditing {
//                    Button(action: {
//                        vm.isEditing = false
////                        vm.updatePhase(selectedPhase: vm.selectedPhase)
//                    }) {
//                        Text("Done")
//                    }
//                } else {
//                    Button(action: {
//                        vm.isEditing = true
//                    }) {
//                        Text("Edit")
//                    }
//                }
//            }
//        }
    }
}


