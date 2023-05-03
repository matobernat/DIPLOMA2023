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
        
        
        // Subscribe to changes in allClients
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
        exercisesDataStore.createExercise(exercise) { result in
            // handle error
        }
    }
    
    //TODO: in the future..
    func addCategory(){
        
    }
    
    
    // ... other methods
}
    

// MARK: - Exercises - View
struct ExerciseView: View {
    let items: [ExerciseMock] = DataModelMock.exercises
    let categories: [CategoryMock] = DataModelMock.categories
    let mainTitle: String = "Exercise"
    
    @State private var searchText: String = ""
    @State var selectedCategory: CategoryMock? = nil
    @State var selectedItem: ExerciseMock? = nil
    
    @StateObject private var vm = ExercisesViewModel()
    
    
    var body: some View {
        NavigationSplitView{
            SideBar(categories: vm.categories, title: vm.title, selectedCategory: $vm.selectedCategory)
        } content: {
            if let category = vm.selectedCategory{
            
                ItemsList(
                    selectedItems: selectedItemsByCategory(
                        allItems: vm.exercises,
                        selectedCategory: category),
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
                        ExerciseDetailView(selectedExercise: selectedExercise)
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
            let index = vm.categories.firstIndex { $0.section == .exercise }
            if let index = index {
                vm.selectedCategory = vm.categories[index]
            }

            if let selectedCategory = vm.selectedCategory {
                vm.selectedExercise = vm.exercises.first(where: { $0.categoryIDs.contains(selectedCategory.id) })
            }
        }


    }
    
    
    
//    func selectedItems(allItems:[ExerciseMock]) -> [ExerciseMock] {
//        if let selectedCategory = selectedCategory {
//            if searchText.isEmpty {
//                return allItems.filter {selectedCategory.itemIDs.contains($0.id)}
//            } else {
//                let filteredClients = allItems
//                    .filter { selectedCategory.itemIDs.contains($0.id) }
//                    .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
//                return filteredClients
//            }
//        } else {
//            return []
//        }
//    }
    
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
