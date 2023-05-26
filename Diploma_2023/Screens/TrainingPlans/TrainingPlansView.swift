//
//  TrainingPlansView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
import SwiftUI
import Combine
// MARK: - Exercises - ViewModel
class TrainingPlansViewModel: ObservableObject {
    
    @Published var columnVisibility = NavigationSplitViewVisibility.all
    
    let title = "TrainingProtocols"
    
    
    private let categoryDataStore: CategoryDataStore
    @Published private(set) var categories: [Category] = []
    @Published  var selectedCategory: Category?
    
    
    private let phasesDataStore: PhasesDataStore
    @Published private(set) var phases: [Phase] = []
//    @Published  var selectedPhase: Phase?
    
    private let mezocycleDataStore: MezoDataStore
    @Published private(set) var mezocycles: [Mezocycle] = []
//    @Published  var selectedMezocycle: Mezocycle?
    
    @Published  var selectedItem: IdentifiableItem?
    @Published  var  selectedType: DataType = DataType.phase
    
    private let accountDataStore: AccountDataStore
    @Published  var loggedAccount: Account?
    
    @Published  var searchText: String = ""
    @Published  var isShowingForm = false
    @Published  var isShowingNewPhase = false
    

    
    
    private var cancellables = Set<AnyCancellable>()
    

    
    init() {
        
        self.accountDataStore = AppDependencyContainer.shared.accountDataStore
        self.loggedAccount = accountDataStore.loggedAccount
        
        self.categoryDataStore = AppDependencyContainer.shared.categoryDataStore
        self.categories = categoryDataStore.categoriesClients
        
        self.phasesDataStore = AppDependencyContainer.shared.phasesDataStore
        self.phases = phasesDataStore.allPhases
        
        self.mezocycleDataStore = AppDependencyContainer.shared.mezoDataStore
        self.mezocycles = mezocycleDataStore.allMezos
        

    
        
        // Subscribe to changes in allPhases
        phasesDataStore.$allPhases.sink { [weak self] newPhases in
            self?.phases = newPhases
        }
        .store(in: &cancellables)
        
        
        // Subscribe to changes in allMezocycles
        mezocycleDataStore.$allMezos.sink { [weak self] newMezocycles in
            self?.mezocycles = newMezocycles
        }
        .store(in: &cancellables)

        
        // Subscribe to changes in categories
        categoryDataStore.$categoriesTrainingPlans.sink { [weak self] newCategories in
            self?.categories = newCategories
        }
        .store(in: &cancellables)
    }
    
    
    
    // This function is called in Child View with object created by Child ViewModel
    // this keeps business logic to this VM and Form logic to child's VM
    func addMezocyle(newMezocycle: Mezocycle){
        mezocycleDataStore.createMezo(newMezocycle) { result in
            // handle error
        }
    }
    
    func updateMezocyle(newMezocycle: Mezocycle){
        mezocycleDataStore.updateMezo(newMezocycle) { result in
            // handle error
        }
    }
    
    // This function is called in Child View with object created by Child ViewModel
    // this keeps business logic to this VM and Form logic to child's VM
    func addPhase(newPhase: Phase){
        phasesDataStore.createPhase(newPhase){ result in
            // handle error
        }
    }
    
    }



// MARK: - TrainingPlans - View
struct TrainingPlansView: View {
    
    
    @StateObject private var vm = TrainingPlansViewModel()
    
    
    var body: some View {
        NavigationSplitView(columnVisibility: $vm.columnVisibility) {
            SideBar(categories: vm.categories, title: vm.title, selectedCategory: $vm.selectedCategory)
        } detail: {
            NavigationStack{
                
                if let category = vm.selectedCategory{
                    SearchBar(searchText: $vm.searchText)

                    if vm.searchText.isEmpty {
                        TrainingPlansViewDetail(vm: vm)
                    } else {
                        TrainingPlansViewDetailSearch(vm: vm)
                    }
                } else {
                    Text("Select a category")
                }
            }
            .navigationTitle(vm.selectedCategory?.name ?? "Select a category")
        }
        .onAppear {
            let index = vm.categories.firstIndex{$0.dataType == .trainingPlan}
            if let index = index {
                vm.selectedCategory = vm.categories[index]
            }
            
        }
    }
}






struct TrainingPlansViewDetail: View{
    
    @ObservedObject var vm: TrainingPlansViewModel

    var body: some View{
            ScrollView{ // might create performance issues
                SegmentPicker(selectedType: $vm.selectedType)
                if vm.selectedType == DataType.mezocycle{
                                    
                    GeneralHorizontalListView(title: "Mezocycles", items: selectedItemsByCategory(allItems: vm.mezocycles, selectedCategory: vm.selectedCategory), titleSize: .large, sizeModel: .large, dataType: .mezocycle, addFunc:{vm.isShowingForm = true; vm.columnVisibility = .detailOnly; vm.isShowingNewPhase = false})
                }else{
                    
                    GeneralHorizontalListView(title: "Phases", items: selectedItemsByCategory(allItems: vm.phases, selectedCategory: vm.selectedCategory), titleSize: .large, sizeModel: .large, dataType: .phase, addFunc:{vm.isShowingForm = true; vm.columnVisibility = .detailOnly; vm.isShowingNewPhase = true})
                }
                
                
            }
            .navigationDestination(
                 isPresented: $vm.isShowingForm) {
                     if vm.isShowingNewPhase{
                         NewPhaseSheetView(parentVm: vm)
                     }
                     else{
                         NewMezocycleView(parentVm: vm)
                     }
                 }
        
    }
    
}




struct TrainingPlansViewDetailSearch: View{
    
    @ObservedObject var vm: TrainingPlansViewModel
    
    var body: some View{
    
        if vm.selectedType == DataType.mezocycle{
            GeneralGridListView(
                items: selectedItemsSearch(
                    allItems: vm.mezocycles,
                    selectedCategory: vm.selectedCategory,
                    searchText: vm.searchText),
                title: "Mezocycles",
                dataType: .mezocycle,
                sizeModel: SizeModelMock.large

            )
        }else{
            GeneralGridListView(
                items: selectedItemsSearch(
                    allItems: vm.phases,
                    selectedCategory: vm.selectedCategory,
                    searchText: vm.searchText),
                title: "Phases",
                dataType: .phase,
                sizeModel: SizeModelMock.large
            )
        }
    }
}


struct SegmentPicker: View{
    @Binding var selectedType: DataType
    
    var body: some View{
        VStack {
            Picker("What is your favorite color?", selection: $selectedType) {
                Text("Short Period").tag(DataType.phase)
                Text("Long Period").tag(DataType.mezocycle)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 50)
        }
    }
}

struct AddButton: View {
    
    @ObservedObject var vm: TrainingPlansViewModel
    
    var body: some View {
        Button {
            if vm.selectedType == DataType.mezocycle{
                print("ADD MEZOCYCLE")
            }
            else{
                print("ADD PHASE")
            }
            
        } label: {
            LargeCardButtonLabel(type: vm.selectedType)
        }

    }
}


struct TrainingPlansView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingPlansView()
    }
}
