//
//  ExerciseView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import SwiftUI
import Combine
// MARK: - Exercises - ViewModel
class ExercisesViewModel: ObservableObject {
    
    
    let title = "Exercises"
    
    
    private let categoryDataStore: CategoryDataStore
    @Published private(set) var categories: [Category] = []
    @Published  var selectedCategory: Category?
    
    
    private let exercisesDataStore: ExercisesDataStore
    @Published private(set) var exercises: [Exercise] = []
    @Published  var selectedExercise: Exercise?
    
    
    private let accountDataStore: AccountDataStore
    @Published  var loggedAccount: Account?
    
    @Published  var searchText: String = ""
    @Published  var isShowingForm = false
    
    
    private var cancellables = Set<AnyCancellable>()
    

    
    init() {
        
        self.exercisesDataStore = AppDependencyContainer.shared.exercisesDataStore
        self.exercises = exercisesDataStore.allExercises
        

        self.categoryDataStore = AppDependencyContainer.shared.categoryDataStore
        self.categories = categoryDataStore.categoriesClients
        
        self.accountDataStore = AppDependencyContainer.shared.accountDataStore
        self.loggedAccount = accountDataStore.loggedAccount
        
        
        // Subscribe to changes in allExercises
        exercisesDataStore.$allExercises.sink { [weak self] newExercises in
            self?.exercises = newExercises
        }
        .store(in: &cancellables)

        
        // Subscribe to changes in categories
        categoryDataStore.$categoriesExercises.sink { [weak self] newCategories in
            self?.categories = newCategories
        }
        .store(in: &cancellables)
    }
    
    
    func createExercise(exercise: Exercise){
        print("CREATE EXERCISE")
        exercisesDataStore.createExercise(exercise) { result in
            // handle error
        }
    }
    
    
    func archiveExercise(){
        self.selectedExercise?.categoryIDs = categoryDataStore.getCategoryIDs(subStrings: ["Archived"], section: .exercise)
        exercisesDataStore.updateExercise(selectedExercise!) { result in
            // handle error
        }
    }
    
    func updateExercise(selectedExercise: Exercise){
        exercisesDataStore.updateExercise(selectedExercise) { result in
            // handle error
            self.selectedExercise = selectedExercise
        }
    }
    
    func deleteExercise(selectedExercise: Exercise){
        exercisesDataStore.deleteExercise(selectedExercise, for: loggedAccount!.id) { result in
            // handle error
        }
    }
    
    
    
    //TODO: in the future..
    func addCategory(){
        
    }
    
    
    // UI func:  takes data from exercise, returns data format for UI InfoRow Component
    func getInfoRowItems() -> [InfoRowItem] {
        
        if self.selectedExercise == nil{
            return []
        }
        var infoRowItems = [InfoRowItem]()
        let cardTitles = ["Body Part", "Recovery", "Base", "Difficulty"]
        let cardDescriptions = ["","","",""]
        var cardValues = [
            self.selectedExercise!.bodyPart,
            self.selectedExercise!.recovery == true ? "Yes":"No",
            self.selectedExercise!.baseMovement,
            self.selectedExercise!.difficulty
        ]
        
        for index in 0..<cardTitles.count {
            let infoRowItem = InfoRowItem(
                title: cardTitles[index],
                value: cardValues[index],
                description: cardDescriptions[index]
            )
            infoRowItems.append(infoRowItem)
        }
        return infoRowItems
    }
    // ... other methods
}
    

// MARK: - Exercises - View
struct ExerciseView: View {
    
    @StateObject private var vm = ExercisesViewModel()
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility){
            SideBar(categories: vm.categories, title: vm.title, selectedCategory: $vm.selectedCategory)
        } content: {
            if let category = vm.selectedCategory{
            
                ItemsList(
                    selectedItems: selectedItemsSearch(
                        allItems: vm.exercises,
                        selectedCategory: category,
                        searchText: vm.searchText),
                    selectedCategory: vm.selectedCategory,
                    selectedItem: $vm.selectedExercise,
                    searchText: $vm.searchText)
                .navigationTitle(vm.selectedCategory?.name ?? "")
                .searchable(text: $vm.searchText)
                .navigationBarItems(trailing: Button(action: {
                    // Add your action here
                    vm.isShowingForm = true
                    print("vm.isShowingForm = \(vm.isShowingForm)")
                }, label: {
                        Image(systemName: "plus")
                }))
                
                
            } else {
                Text("Select a category")
            }

                
        } detail: {
            NavigationStack{
                if let selectedExercise = vm.selectedExercise {
                    ExerciseDetailView(vm:vm)
                } else {
                    Text("No item selected")
                }
            }
            .navigationTitle(vm.selectedExercise?.title ?? "Select an Exercise")

            
            .sheet(isPresented: $vm.isShowingForm) {
                NewExerciseView(parentVm: vm)
//                        NewExerciseView(isShowingForm: $vm.isShowingForm, parentVm: vm)
            }
        }
        
        .onAppear {
            vm.selectedCategory = vm.categories[0]
            

            if let selectedCategory = vm.selectedCategory {
                vm.selectedExercise = vm.exercises.first(where: { $0.categoryIDs.contains(selectedCategory.id) })
            }
        }
    }
}





struct ItemsList: View {
    let selectedItems: [Exercise]
    let selectedCategory: Category?
    @Binding var selectedItem: Exercise?
    @Binding var searchText: String


    var body: some View {
            List(selectedItems, id: \.id, selection: $selectedItem) { item in
                NavigationLink(value: item) {
                    itemRow(item: item)
                }
            }
        }
    
    private func itemRow(item: IdentifiableItem) -> some View {
        HStack {
            Text(verbatim: item.title)
        }
    }
    
}



struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView()
    }
}
