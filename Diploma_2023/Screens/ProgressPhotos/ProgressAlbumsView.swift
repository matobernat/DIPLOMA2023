//
//  ProgressAlbumsView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 03/07/2023.
//

import SwiftUI
import Combine


// MARK: - ProgressAlbum - ViewModel
class ProgressAlbumsViewModel: ObservableObject {
    
    let title = "Progress Photos"
    
    // Categories
    private let categoryDataStore: CategoryDataStore
    @Published private(set) var categories: [Category] = []
    @Published var selectedCategory: Category?
    
    
    // Clients
    private let clientsDataStore: ClientsDataStore
    @Published private(set) var clients: [Client] = []
    @Published var clientItems: [(Client, title: String, imageUrl: String?, placeholderName: String?)] = []
    
    // Progress Albums
    @Published private(set) var progressAlbums: [ProgressAlbum] = []
    @Published var selectedItem: ProgressAlbum?
    @Published var newItem: ProgressAlbum?
    
    
    // Local
    @Published var searchText: String = ""
    @Published var isShowingForm: Bool = false
    @Published var isShowingSelectableClientList: Bool = false
    @Published var columnVisibility = NavigationSplitViewVisibility.all


    
    private var cancellables = Set<AnyCancellable>()
    
    // __ Init __
    init(
        clientsDataStore: ClientsDataStore = AppDependencyContainer.shared.clientsDataStore,
        categoryDataStore: CategoryDataStore = AppDependencyContainer.shared.categoryDataStore,
        imageRepository: ImageRepository = AppDependencyContainer.shared.imageRepository
    ) {
        
        
        self.categoryDataStore = categoryDataStore
        self.clientsDataStore = clientsDataStore
        
        
        // ProgressAlbums
        clientsDataStore.$allProgressAlbums.sink { [weak self] newProgressAlbums in
            self?.progressAlbums = newProgressAlbums
        }
        .store(in: &cancellables)
        
        // Categories
        categoryDataStore.$categoriesProgressAlbum.sink { [weak self] newCategories in
            self?.categories = newCategories
        }
        .store(in: &cancellables)
        
        // Clients
        self.clientsDataStore.$allClients.sink { [weak self] newClients in
            self?.clients = newClients
            // Transform newClients into clientItems
            self?.clientItems = newClients.map { ($0, $0.title, $0.imageUrl, $0.placeholderName) }
        }
        .store(in: &cancellables)
        
    }
    
    func addProgressAlbum(newProgressAlbum: ProgressAlbum){
        clientsDataStore.updateProgressAlbum(progressAlbum: newProgressAlbum) { result in
            // handle error
        }
    }
    
    func updateProgressAlbum(newProgressAlbum: ProgressAlbum){
        clientsDataStore.updateProgressAlbum(progressAlbum: newProgressAlbum) { result in
            // handle error
        }
    }
    
    // new album is also uploaded to client
    func getNewAlbum(selectedClient: Client, selectedCategory: Category) -> ProgressAlbum {
        var selectedClient = selectedClient
        let newAlbum = ProgressAlbum.getNewAlbum(
            selectedClient: selectedClient,
            categoryIDs: categoryDataStore.getCategoryIDs(selectedCategory: selectedCategory))
        selectedClient.progressAlbums.append(newAlbum)
        
        self.clientsDataStore.updateClient(selectedClient) { result in
            // handle the error
        }
        
        return newAlbum
    }
}





// MARK: - ProgressAlbum - View
struct ProgressAlbumsView: View {
    
    @StateObject private var vm = ProgressAlbumsViewModel()
    
    
    var body: some View {
        NavigationSplitView(columnVisibility: $vm.columnVisibility) {
            SideBar(categories: vm.categories, title: vm.title, selectedCategory: $vm.selectedCategory)
        } detail: {
            NavigationStack{
                
                if let category = vm.selectedCategory{
                    SearchBar(searchText: $vm.searchText)
                    
                    if vm.searchText.isEmpty {
                        ProgressAlbumsDetailView(vm: vm)
                    } else {
                        ProgressAlbumsDetailSearchView(vm: vm)
                    }
                } else {
                    Text("Select a category")
                }
            }
            .navigationTitle(vm.selectedCategory?.name ?? "Select a category")
        }
        .onAppear {
            let index = vm.categories.firstIndex{$0.dataType == .progressAlbum}
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
                        vm.newItem = vm.getNewAlbum(selectedClient: selectedItem, selectedCategory: vm.selectedCategory!)
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



struct ProgressAlbumsDetailView: View {
    
    @ObservedObject var vm: ProgressAlbumsViewModel

    var body: some View{
            ScrollView{ // might create performance issues

                GeneralHorizontalListView(title: "ProgressAlbums",
                                          items: selectedItemsByCategory(allItems: vm.progressAlbums, selectedCategory: vm.selectedCategory),
                                          titleSize: .large,
                                          sizeModel: .large,
                                          dataType: .progressAlbum,
                                          addFunc:
                                            {
//                    vm.isShowingForm = true;
                    vm.isShowingSelectableClientList = true;
                    vm.columnVisibility = .all;
                    
                })
                
//                GeneralHorizontalListView(title: "Mezocycles", items: selectedItemsByCategory(allItems: vm.mezocycles, selectedCategory: vm.selectedCategory), titleSize: .large, sizeModel: .large, dataType: .mezocycle, addFunc:{vm.isShowingForm = true; vm.columnVisibility = .detailOnly; vm.isShowingNewPhase = false})
                
            }
            .navigationDestination(
                 isPresented: $vm.isShowingForm) {
                     
//                     NewAlbumView(selectedCategory: vm.selectedCategory!)
                     if let newItem = vm.newItem{
                         ProgressAlbumsDetail(item: newItem)
                     }
                 }
        
    }
    
}




struct ProgressAlbumsDetailSearchView: View{
    
    @ObservedObject var vm: ProgressAlbumsViewModel
    
    var body: some View{
        GeneralGridListView(
            items: selectedItemsSearch(
                allItems: vm.progressAlbums,
                selectedCategory: vm.selectedCategory,
                searchText: vm.searchText),
            title: "Progress Albums",
            dataType: .progressAlbum,
            sizeModel: SizeModelMock.large

        )
    }
}
