//
//  NewMezocycleView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 22/03/2023.
//

import Combine
import SwiftUI

// MARK: - NewMezo - ViewModel
class NewMezocycleViewModel: ObservableObject {
    
    @Published var newMezo:Mezocycle

    //FORM MEZO PROPERTIES
    @Published var title: String = ""
    @Published var durationInMonths: String = ""
    @Published var trainingFocus: String = ""
    @Published var intensity: String = ""
    @Published var progressionStrategy: String = ""
    @Published var totalTrainings: String = ""
    @Published var description: String = ""
    
    var categories: [Category]
    var selectedCategory: Category
    var loggedAccount: Account
    
    
    // PHASE
    private let phasesDataStore: PhasesDataStore
    @Published var phases: [Phase]
    @Published var isShowingEditPhases = false
    @Published var isShowingSheet = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(categories: [Category], selectedCategory: Category, loggedAccount: Account) {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.loggedAccount = loggedAccount
        
        self.newMezo = Mezocycle(
            title: "",
            categoryIDs: AppDependencyContainer.shared.categoryDataStore.getCategoryIDs(selectedCategory: self.selectedCategory),
            dateOfCreation: .now,
            accountID: loggedAccount.id,
            profileID: loggedAccount.loggedProfile?.id ?? "",
            clientName: "",
            phases: [Phase](),
            durationInMonths: "",
            trainingFocus: "",
            intensity: "",
            progressionStrategy: "",
            totalTrainings: "",
            description: "")
        
        // PHASES MANAGEMENT
        self.phasesDataStore = AppDependencyContainer.shared.phasesDataStore
        self.phases = phasesDataStore.allPhases
        // Subscribe to changes in Exercises
        phasesDataStore.$allPhases.sink { [weak self] newExercises in
            self?.phases = newExercises
        }
        .store(in: &cancellables)
    }// init
    
    
    func fillMockMezocycle() {
        self.newMezo = Mezocycle(
            title: title,
            categoryIDs: AppDependencyContainer.shared.categoryDataStore.getCategoryIDs(selectedCategory: self.selectedCategory),
            dateOfCreation: .now,
            accountID: loggedAccount.id,
            profileID: loggedAccount.loggedProfile?.id ?? "",
            clientName: "",
            phases: [Phase](),
            durationInMonths: durationInMonths,
            trainingFocus: trainingFocus,
            intensity: intensity,
            progressionStrategy: progressionStrategy,
            totalTrainings: totalTrainings,
            description: description)

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
        self.newMezo = self.newMezo.randomizeAttributes()
        self.title = self.newMezo.title
        self.durationInMonths  = self.newMezo.durationInMonths
        self.trainingFocus = self.newMezo.trainingFocus
        self.intensity  = self.newMezo.intensity
        self.progressionStrategy = self.newMezo.progressionStrategy
        self.totalTrainings = self.newMezo.totalTrainings
        self.description = self.newMezo.description
    }
}



// MARK: - NewMezo - View
struct NewMezocycleView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var parentVm: TrainingPlansViewModel
    @ObservedObject private var vm: NewMezocycleViewModel
    
    @State private var textFields: [String] = Array(repeating: "", count: 8)
    private let placeholders = ["Mezocycle Name", "Duration (in months)", "Training Focus", "Intensity", "Progression Strategy", "Total Trainings", "Description"]

    
    init( parentVm: TrainingPlansViewModel) {
        self.parentVm = parentVm
        self.vm = NewMezocycleViewModel(categories: parentVm.categories,
                                     selectedCategory: parentVm.selectedCategory!,
                                     loggedAccount: parentVm.loggedAccount!)
        
    }

    
    var body: some View {
        NavigationStack{
            

            ScrollView {
                
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
                .padding(.horizontal, 40)
                // Add + Edit BUTTONS
                Divider()
                buttonsView()
                    .padding(.horizontal, 50)
                VStack{
                    GeneralHorizontalListView(title: "Added Phases", items: vm.newMezo.phases, titleSize: .large, sizeModel: .large, dataType: .phase, hideDivider: true)
                }
            }
        
        }
        .navigationTitle("New Mezocycle")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    print("CANCEL")
                }) {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    parentVm.addMezocyle(newMezocycle: vm.newMezo)
                    presentationMode.wrappedValue.dismiss()
                    print("SAVE")
                }) {
                    Text("Save")
                }
            }
        }
        .sheet(isPresented: $vm.isShowingSheet) {
            
            if vm.isShowingEditPhases {
                EditPhasesListView( mezo: $vm.newMezo, phases: $vm.newMezo.phases)

            } else {
                AddPhasesToMezoListView(vm: parentVm, mezo: $vm.newMezo, phases: $vm.phases)
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
//
//struct NewMezocycleView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewMezocycleView()
//    }
//}


struct AddPhasesToMezo: View{
    let items: [IdentifiableItem]
    let createCardView: (IdentifiableItem) -> AnyCardView
    let createDetailView: (IdentifiableItem) -> AnyDetailView
    let sizeModel: SizeModelMock
    

    var body: some View{
        if items.isEmpty {
            VStack {
                Text("No items found")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(.top, 50)
                Spacer()
            }
        }
        else{
            NavigationStack{
//                LazyVGrid(columns: columns, spacing: 16) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: columnSize(sizeModel: sizeModel)))], spacing: 16) {
                    ForEach(items, id: \.id) { item in
                        NavigationLink(destination: createDetailView(item)) {
                            createCardView(item)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
    }
    
    func columnSize(sizeModel: SizeModelMock) -> CGFloat {
        switch sizeModel{
            
        case .large:
            return 160
        case .medium:
            return 220
        case .small:
            return 160
        }
    }
}


