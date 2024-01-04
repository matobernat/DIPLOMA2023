//
//  MeasurementsView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 09/07/2023.
//
import SwiftUI
import Combine


// MARK: - Measurements - ViewModel
class MeasurementsViewModel: ObservableObject {
    
    let title = "Measurements"
    
    // Categories
    private let categoryDataStore: CategoryDataStore
    @Published private(set) var categories: [Category] = []
    @Published var selectedCategory: Category?
    
    
    // Clients
    private let clientsDataStore: ClientsDataStore
    @Published private(set) var clients: [Client] = []
    @Published var clientItems: [(Client, title: String, imageUrl: String?, placeholderName: String?)] = []
    
    
    // Measurements
    @Published private(set) var measurements: [Measurements] = []
    @Published var selectedMeasurements: Measurements?
    @Published var newItem: Measurements?
    

    // Local
    @Published var searchText: String = ""
    @Published var isShowingForm: Bool = false
    @Published var isShowingSelectableClientList: Bool = false
    @Published var columnVisibility = NavigationSplitViewVisibility.all

    
    private var cancellables = Set<AnyCancellable>()
    
    // __ Init __
    init(
        clientsDataStore: ClientsDataStore = AppDependencyContainer.shared.clientsDataStore,
        categoryDataStore: CategoryDataStore = AppDependencyContainer.shared.categoryDataStore
    ) {
        
        // Client Category Data Stores
        self.categoryDataStore = categoryDataStore
        self.clientsDataStore = clientsDataStore
        
        // Measurements fetching
        self.clientsDataStore.$allMeasurements.sink { [weak self] newMeasurements in
            self?.measurements = newMeasurements
        }
        .store(in: &cancellables)
        
        // Categories fetching
        self.categoryDataStore.$categoriesMeasurements.sink { [weak self] newCategories in
            self?.categories = newCategories
        }
        .store(in: &cancellables)

        
        // Clients fetching
        self.clientsDataStore.$allClients.sink { [weak self] newClients in
            self?.clients = newClients
            // Transform newClients into clientItems
            self?.clientItems = newClients.map { ($0, $0.title, $0.imageUrl, $0.placeholderName) }
        }
        .store(in: &cancellables)
        
    }

    
    func addMeasurements(newMeasurements: Measurements) {
        clientsDataStore.updateMeasurements(measurements: newMeasurements) { result in
            // handle error
        }
    }
    
    func updateMeasurement(newMeasurements: Measurements) {
        clientsDataStore.updateMeasurements(measurements: newMeasurements) { result in
            // handle error
        }
    }
    
    // new measurements is also uploaded to client
    func getNewMeasuremets(selectedClient: Client, selectedCategory: Category) -> Measurements {
        var selectedClient = selectedClient
        let newMeasurements = Measurements.getNewMeasurements(
            selectedClient: selectedClient,
            categoryIDs: categoryDataStore.getCategoryIDs(selectedCategory: selectedCategory))
        selectedClient.measurements.append(newMeasurements)
        
        self.clientsDataStore.updateClient(selectedClient) {
            result in
            // handle the error
        }
        
        return newMeasurements
    }
}

// MARK: - Measurements - View
struct MeasurementsView: View {
    
    @StateObject private var vm = MeasurementsViewModel()
    
    // Body remains mostly the same, only change the object type and adjust accordingly
    var body: some View {
        NavigationSplitView(columnVisibility: $vm.columnVisibility) {
            SideBar(categories: vm.categories, title: vm.title, selectedCategory: $vm.selectedCategory)
        } detail:
        {
            NavigationStack{
                
                if let category = vm.selectedCategory{
                    SearchBar(searchText: $vm.searchText)
                    
                    if vm.searchText.isEmpty {
                        
                        MeasurementsContentView(vm: vm)

                    } else {
                        MeasurementsContentSearchView(vm: vm)
                    }
                } else {
                    Text("Select a category")
                }
            }
            .navigationTitle(vm.selectedCategory?.name ?? "Select a category")
        }
        .onAppear {
            let index = vm.categories.firstIndex{$0.dataType == .measurement}
            if let index = index {
                vm.selectedCategory = vm.categories[index]
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
                        vm.newItem = vm.getNewMeasuremets(selectedClient: selectedItem, selectedCategory: vm.selectedCategory!)
                        vm.isShowingSelectableClientList = false
                        vm.isShowingForm = true
                        print(selectedItems.first?.title)

                    }
                }, onCancel: {
                    vm.isShowingSelectableClientList = false
                }
            )
        }

        
    }
}

struct MeasurementsContentView: View {

    @ObservedObject var vm: MeasurementsViewModel

    var body: some View{
            ScrollView{ // might create performance issues

                GeneralHorizontalListView(title: "Measurements",
                                          items: selectedItemsByCategory(allItems: vm.measurements, selectedCategory: vm.selectedCategory),
                                          titleSize: .large,
                                          sizeModel: .large,
                                          dataType: .measurement,
                                          addFunc:
                                            {
//                    vm.isShowingForm = true;
                    vm.isShowingSelectableClientList = true;
                    vm.columnVisibility = .all;
                    
                })
                
                
            }
            .navigationDestination(
                 isPresented: $vm.isShowingForm) {
                     
//                     NewAlbumView(selectedCategory: vm.selectedCategory!)
                     if let newItem = vm.newItem{
                         MeasurementsDetailView(item: newItem)
                     }
                 }
        
    }
    
}

struct MeasurementsContentSearchView: View {

    @ObservedObject var vm: MeasurementsViewModel

    var body: some View{
        GeneralGridListView(
            items: selectedItemsSearch(
                allItems: vm.measurements,
                selectedCategory: vm.selectedCategory,
                searchText: vm.searchText),
            title: "Measurements",
            dataType: .measurement,
            sizeModel: SizeModel.large

        )
    }
}
