//
//  FoodPlansView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/10/2023.
//

import SwiftUI
import Combine


// MARK: - FoodPlans - ViewModel
class FoodPlansViewModel: ObservableObject {
    
    let title = "Food Protocols"
    
    // Categories
    private let categoryDataStore: CategoryDataStore
    @Published private(set) var categories: [Category] = []
    @Published var selectedCategory: Category?
    
    
    // Clients
    private let clientsDataStore: ClientsDataStore
    @Published private(set) var clients: [Client] = []
    @Published var clientItems: [(Client, title: String, imageUrl: String?, placeholderName: String?)] = []
    
    
    // FoodPlans
    private let foodPlansDataStore: FoodPlansDataStore
    @Published private(set) var foodPlans: [FoodPlan] = []
//    @Published var newItem: FoodPlan?
    

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
        foodPlansDataStore: FoodPlansDataStore = AppDependencyContainer.shared.foodPlansDataStore
    ) {
        
        // Client Category FoodPlan DataStores
        self.categoryDataStore = categoryDataStore
        self.clientsDataStore = clientsDataStore
        self.foodPlansDataStore = foodPlansDataStore
        
        
        // FoodPlans fetching
        self.foodPlansDataStore.$allFoodPlans.sink { [weak self] newFoodPlans in
            self?.foodPlans = newFoodPlans
        }
        .store(in: &cancellables)
        
        
        // Categories fetching
        self.categoryDataStore.$categoriesFoodPlans.sink { [weak self] newCategories in
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

    
    func printInit(){
        print("INIT FoodPlansContentView")
    }
    
    
    func createFoodPlan() {
        
        // Bit of a quick workaround to get accountID & profileID
        let accountDataStore = AppDependencyContainer.shared.accountDataStore
        
        let newFoodPlan = FoodPlan(
            title: "Food Protocol Template 1.1",
            subTitle: "Imageless Food Protocol Template",
            categoryIDs: self.categoryDataStore.getCategoryIDs(selectedCategory: selectedCategory!),
            dateOfCreation: Date(),
            accountID: accountDataStore.loggedAccount!.id,
            profileID: accountDataStore.loggedAccount!.loggedProfile!.id,
            apiKey: FoodPlan.apiKey,
            pdfMonkeyTemplateID: FoodPlan.template2_ID, //MONKEY TEMPLATE
            inputData: FoodPlan.convertJSONStringToFoodPlanData(FoodPlan.template3_InputData)! //MONKEY PAYLOAD
  
        )
        
        foodPlansDataStore.createAndRetrieveDocument(
            withPayload: FoodPlan.template3_InputData, //MONKEY PAYLOAD
            forFoodPlan: newFoodPlan) { result in
                print ("FULL PIPELINE RESULT: \(result)")
            }
    }
}
    
    
    
// MARK: - FoodPlans - View
struct FoodPlansView: View {
    
    @StateObject private var vm = FoodPlansViewModel()
    
    // Body remains mostly the same, only change the object type and adjust accordingly
    var body: some View {
        NavigationSplitView(columnVisibility: $vm.columnVisibility) {
            SideBar(categories: vm.categories, title: vm.title, selectedCategory: $vm.selectedCategory)
        } detail: {
            NavigationStack{
                
                if vm.selectedCategory != nil{
                    SearchBar(searchText: $vm.searchText)
                    
                    if vm.searchText.isEmpty {
                        FoodPlansContentView(vm: vm)
                    } else {
                        FoodPlansContentSearchView(vm: vm)
                    }
                } else {
                    Text("Select a category")
                }
            }
            .navigationTitle(vm.selectedCategory?.name ?? "Select a category")
        }
        .onAppear {
            let index = vm.categories.firstIndex{$0.dataType == .foodPlan}
            if let index = index {
                vm.selectedCategory = vm.categories[index]
            }
        }
        
        
    }
}




struct FoodPlansContentView: View {

    @ObservedObject var vm: FoodPlansViewModel

    var body: some View{
            ScrollView{ // might create performance issues
                
                GeneralHorizontalListView(title: "Food Protocols",
                                          items: selectedItemsByCategory(allItems: vm.foodPlans,
                                                                         selectedCategory: vm.selectedCategory),
                                          titleSize: .large,
                                          sizeModel: .large,
                                          dataType: .foodPlan,
                                          addFunc:
                                            {
                    print("New item")
                    vm.columnVisibility = .all;
                    vm.createFoodPlan()
                })
                
            }
            .navigationDestination(
                 isPresented: $vm.isShowingForm) {
                     
                     // Nothing yet, just text
                     Text("Hello NEW Item")

                 }
        
    }
    
}


struct FoodPlansContentSearchView: View {

    @ObservedObject var vm: FoodPlansViewModel

    var body: some View{
        GeneralGridListView(
            items: selectedItemsSearch(
                allItems: vm.foodPlans,
                selectedCategory: vm.selectedCategory,
                searchText: vm.searchText),
            title: "Food Protocols",
            dataType: .foodPlan,
            sizeModel: SizeModel.large

        )
    }
}



