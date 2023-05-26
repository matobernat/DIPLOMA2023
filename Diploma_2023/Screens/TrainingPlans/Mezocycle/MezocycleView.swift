//
//  MezocycleView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 22/03/2023.
//

import SwiftUI
import Combine
// MARK: - Mezocycle - ViewModel
class MezocycleViewModel: ObservableObject {
    
    
    //FORM MEZO PROPERTIES
    @Published var title: String = ""
    @Published var durationInMonths: String = ""
    @Published var trainingFocus: String = ""
    @Published var intensity: String = ""
    @Published var progressionStrategy: String = ""
    @Published var totalTrainings: String = ""
    @Published var description: String = ""
    
    
    
    
    private let mezoDataStore: MezoDataStore
    @Published var selectedMezo:Mezocycle
    private var selectedClient: Client? = nil
    @Published var isEditing = false
    @Published var isShowingSheet: Bool = false
    @Published var isShowingSheetList = false
    @Published var isShowingEditPhases = false
    @Published var isShowingClientList = false

    @Published var searchText = ""

    private let clientsDataStore: ClientsDataStore
    @Published var clients:[Client]
    
    private let phaseDataStore: PhasesDataStore
    @Published var phases: [Phase] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(selectedMezo: Mezocycle, selectedClient: Client? = nil) {
        
        self.selectedMezo = selectedMezo
        
        // Mezo MANAGEMENT
        self.mezoDataStore = AppDependencyContainer.shared.mezoDataStore
        
        // Phase MANAGEMENT
        self.phaseDataStore = AppDependencyContainer.shared.phasesDataStore
        
        
        self.clientsDataStore = AppDependencyContainer.shared.clientsDataStore
        self.clients = clientsDataStore.allClients
        
        
        clientsDataStore.$allClients.sink { [weak self] newClients in
            self?.clients = newClients
        }
        .store(in: &cancellables)
        
        // Subscribe to changes in Phases
        phaseDataStore.$allPhases.sink { [weak self] newPhases in
            self?.phases = newPhases
        }
        .store(in: &cancellables)
        
    }

    
    func binding(for index: Int) -> Binding<String> {
        switch index {
        case 0: return Binding(get: { self.title }, set: { self.title = $0 })
        case 1: return Binding(get: { self.durationInMonths }, set: { self.durationInMonths = $0 })
        case 2: return Binding(get: { self.trainingFocus }, set: { self.trainingFocus = $0 })
        case 3: return Binding(get: { self.intensity }, set: { self.intensity = $0 })
        case 4: return Binding(get: { self.progressionStrategy }, set: { self.progressionStrategy = $0 })
        case 5: return Binding(get: { self.totalTrainings }, set: { self.totalTrainings = $0 })
        case 6: return Binding(get: { self.description }, set: { self.description = $0 })
        default: return Binding.constant("")
        }
    }
    
    func fillMezocycle(){
        self.title = self.selectedMezo.title
        self.durationInMonths  = self.selectedMezo.durationInMonths
        self.trainingFocus = self.selectedMezo.trainingFocus
        self.intensity  = self.selectedMezo.intensity
        self.progressionStrategy = self.selectedMezo.progressionStrategy
        self.totalTrainings = self.selectedMezo.totalTrainings
        self.description = self.selectedMezo.description
    }
    
//MARK: CRUD operations
    
    func addMezoToClient(selectedMezo: Mezocycle, client: Client){
        clientsDataStore.updateClient(client.addMezo(mezo: selectedMezo, existingTitles: [], keepName: false)) { result in
            // handle error
            print(result)
            print("CLIENT UPDATED_______________")
        }
    }
    
    
    func duplicateMezo(selectedMezo: Mezocycle){
        
        if let selectedClient = AppDependencyContainer.shared.clientsDataStore.getClient(clientID: selectedMezo.clientID) {
            
            let allTitles = selectedClient.mezocycles.map { $0.title }
            AppDependencyContainer.shared.clientsDataStore.updateClient(selectedClient.addMezo(mezo: selectedMezo, existingTitles: allTitles, keepName: true)) { result in
                // handle error
            }
        } else {
            let allTitles = AppDependencyContainer.shared.mezoDataStore.allMezos.map { $0.title }
            mezoDataStore.createMezo(selectedMezo.duplicate(existingTitles: allTitles)) { result in
                //handle result
            }
        }
    }
    
    func updateMezo(selectedMezo: Mezocycle) {
        if let selectedClient = AppDependencyContainer.shared.clientsDataStore.getClient(clientID: selectedMezo.clientID) {
//            AppDependencyContainer.shared.clientsDataStore.updateClient(selectedClient.updateMezo(mezo: selectedMezo)) { result in
                // handle error
//            }
        }
        mezoDataStore.updateMezo(selectedMezo) { result in
            // handle error
        }
    }

    
    func deleteMezo(selectedMezo: Mezocycle){
        if let selectedClient = AppDependencyContainer.shared.clientsDataStore.getClient(clientID: selectedMezo.clientID) {
            AppDependencyContainer.shared.clientsDataStore.updateClient(selectedClient.deleteMezo(mezoID: selectedMezo.id)) { result in
                // handle error
            }
        }
        mezoDataStore.deleteMezo(selectedMezo) { result in
            // handle error
        }
    }
    
    func archiveMezo(selectedMezo: Mezocycle) {
        self.selectedMezo.categoryIDs = AppDependencyContainer.shared.categoryDataStore.getCategoryIDs(subStrings: ["Archived"], section: .trainingPlan)
        self.updateMezo(selectedMezo: selectedMezo)
    }

    
}

// MARK: - Mezocycle - View

struct MezocycleView: View, DetailView {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var vm: MezocycleViewModel
    
    
    
    init(item: IdentifiableItem) {
        self.vm = MezocycleViewModel(selectedMezo: item  as! Mezocycle)
    }
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                MezocycleViewHeader(mezocycle: $vm.selectedMezo)
                GeneralHorizontalListView(
                    title: "Phases",
                    items: vm.selectedMezo.phases ,
                    titleSize: .large,
                    sizeModel: .large,
                    dataType: .phase)
            }
        }
        .onDisappear {
            // Code to clear data or reset flags
            vm.isEditing = false
        }
        .navigationTitle(vm.selectedMezo.title)
        .navigationBarItems(trailing: Button(action: {
            // Empty action, button only used to present ContextMenu
        }, label: {
            Image(systemName: "ellipsis.circle") // This is the "more" button
        }).contextMenu {
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                vm.isShowingSheetList = true
                vm.isShowingSheet = true
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
                vm.duplicateMezo(selectedMezo: vm.selectedMezo)
                // Call your function to delete the client here
            }, label: {
                HStack{
                    Text("Duplicate Mezocycle")
                    Spacer()
                    Image(systemName: "doc.on.doc")
                }
                .foregroundColor(.red)
            })
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                vm.archiveMezo(selectedMezo: vm.selectedMezo)
                // Call your function to delete the client here
            }, label: {
                HStack{
                    Text("Archive Mezocycle")
                    Spacer()
                    Image(systemName: "archivebox")
                }
                .foregroundColor(.red)
            })
            Button(role: .destructive) {
                presentationMode.wrappedValue.dismiss()
                vm.deleteMezo(selectedMezo: vm.selectedMezo)
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
                if vm.isEditing {
                    Button(action: {
                        vm.isEditing = false
                        vm.updateMezo(selectedMezo: vm.selectedMezo)
                    }) {
                        Text("Done")
                    }
                } else {
                    Button(action: {
                        vm.isEditing = true
                    }) {
                        Text("Edit")
                    }
                }
            }
        }
        .sheet(isPresented: $vm.isShowingSheet) {

            if vm.isShowingSheetList{
                addMezoToClientSheet(vm: vm, clients: $vm.clients, mezo: $vm.selectedMezo)
            }
        }
    }
    func buttonsView() -> some View {
        HStack {
            Button(action: {
                vm.isShowingEditPhases = false
                vm.isShowingSheet = true
            }) {
                Label("Add Phase", systemImage: "plus.circle.fill")
                    .padding(.leading, 10)
            }
            
            Spacer()
            
            Button(action: {
                vm.isShowingEditPhases = true
                vm.isShowingSheet = true
            }) {
                Label("Edit Phase", systemImage: "slider.vertical.3")
                    .padding(.leading, 10)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct MezocycleViewHeader: View{
    
    @Binding var mezocycle : Mezocycle
    
    var body: some View{
        VStack(alignment: .leading){
            
            HStack{
                LargeCardImage(item: mezocycle)
                    .padding(.leading, 20)
                VStack{
                    Text(mezocycle.subTitle)
                        .font(.headline)
                        .bold()
                    Text(mezocycle.description)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(10)
                    
                }
            }
            
            Divider()
            
            
            InfoRowView(infoRowItem: mezocycle.getInfoRowItems())
            
        }
    }
}


// ADD PHASE MAYBE??
struct addMezoToClientSheet: View {
    @ObservedObject var vm: MezocycleViewModel
    @Binding var clients: [Client]
    @Binding var mezo: Mezocycle
    @State var searchText = ""

    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                List(selectedItemsSearch(allItems: clients, selectedCategory: nil, searchText: searchText)) { client in
                    
                    HStack {
                        Text(client.title)
                        Spacer()
                        Button {
                            // Action to perform when the button is tapped
                            vm.addMezoToClient(selectedMezo: mezo, client: client)
                        } label: {
                            Label("Add ItemIIIIIK", systemImage: "plus")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.mini)
                        .tint(.accentColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                   
                    }
                }
            }
            .navigationBarTitle("Add Exercises", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        vm.isShowingClientList = true
                        vm.isShowingSheet = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        vm.isShowingClientList = true
                        vm.isShowingSheet = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                    }
                }
            }
        }
    }
}

//struct MezocycleView_Previews: PreviewProvider {
//    static var previews: some View {
////        MezocycleView()
//    }
//}


struct MezocycleHeaderForm: View{
    @State private var textFields: [String] = Array(repeating: "", count: 8)
    private let placeholders = ["Mezocycle Name", "Duration (in months)", "Training Focus", "Intensity", "Progression Strategy", "Total Trainings", "Description"]
    @ObservedObject var vm: MezocycleViewModel
    var body: some View{
        // MEZOCYCLE FORM
        Section {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 40), count: 2), spacing: 10) {
                ForEach(placeholders.indices, id: \.self) { index in
                    TextField(placeholders[index], text: vm.binding(for: index))
                        .font(.system(size: 20))
                        .frame(height: 10)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .keyboardType(index == 1 ? .numberPad : .default)
                }
                Button("Fill Data", action: {print("FILL"); vm.fillMezocycle()})
                    .font(.system(size: 20))
                    .frame(height: 10)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .keyboardType(.default)
            }
        }
    }
    
}
