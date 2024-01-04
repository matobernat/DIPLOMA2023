//
//  EditMezocycleView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 06/06/2023.
//

import SwiftUI
import Combine

// MARK: - EditMezo - ViewModel
class EditMezocycleViewModel: ObservableObject {
    
    @Published var selectedMezo:Mezocycle

    //FORM MEZO PROPERTIES
    @Published var title: String = ""
    @Published var durationInMonths: String = ""
    @Published var trainingFocus: String = ""
    @Published var intensity: String = ""
    @Published var progressionStrategy: String = ""
    @Published var totalTrainings: String = ""
    @Published var description: String = ""
    
    // PHASE
    private let phasesDataStore: PhasesDataStore
    @Published var phases: [Phase]
    @Published var isShowingEditPhases = false
    @Published var isShowingSheet = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(selectedMezo: Mezocycle) {
        
        self.selectedMezo = selectedMezo
        
        // PHASES MANAGEMENT
        self.phasesDataStore = AppDependencyContainer.shared.phasesDataStore
        self.phases = phasesDataStore.allPhases
        // Subscribe to changes in Exercises
        phasesDataStore.$allPhases.sink { [weak self] newPhases in
            self?.phases = newPhases
        }
        .store(in: &cancellables)
        
        // set pairing
        self.fillMezocycle()
    }// init
    
    
    // binding + fillMezocycle is neccessary for having array of bindings 
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
    
    // mapping Object -> Form
    func fillMezocycle(){
        self.title = self.selectedMezo.title
        self.durationInMonths  = self.selectedMezo.durationInMonths
        self.trainingFocus = self.selectedMezo.trainingFocus
        self.intensity  = self.selectedMezo.intensity
        self.progressionStrategy = self.selectedMezo.progressionStrategy
        self.totalTrainings = self.selectedMezo.totalTrainings
        self.description = self.selectedMezo.description
    }
    
    // mapping Form -> Object
    func getUpdatedMezo() -> Mezocycle{
        self.selectedMezo.title = self.title
        self.selectedMezo.durationInMonths  = self.durationInMonths
        self.selectedMezo.trainingFocus = self.trainingFocus
        self.selectedMezo.intensity  = self.intensity
        self.selectedMezo.progressionStrategy = self.progressionStrategy
        self.selectedMezo.totalTrainings = self.totalTrainings
        self.selectedMezo.description = self.description

        return self.selectedMezo
    }
}


// MARK: - EditMezo - View
struct EditMezocycleView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var parentVm: MezocycleViewModel
    @ObservedObject private var vm: EditMezocycleViewModel
    
    @State private var textFields: [String] = Array(repeating: "", count: 8)
//    private let placeholders = ["Mezocycle Name", "Duration (in months)", "Training Focus", "Intensity", "Progression Strategy", "Total Trainings", "Description"]

    
    init( parentVm: MezocycleViewModel) {
        self.parentVm = parentVm
        self.vm = EditMezocycleViewModel(selectedMezo: parentVm.selectedMezo)
        
    }

    
    var body: some View {
        NavigationStack{
            
            ScrollView {
                EditMezocycleHeaderForm(vm: vm)
                .padding(.horizontal, 40)
                // Add + Edit BUTTONS
                Divider()
                buttonsView()
                    .padding(.horizontal, 50)
                VStack{
                    GeneralHorizontalListView(title: "Added Phases", items: vm.selectedMezo.phases, titleSize: .large, sizeModel: .large, dataType: .phase, hideDivider: true)
                }
            }
            
        
        }
        .navigationTitle("Edit Mezocycle")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    parentVm.updateMezo(selectedMezo: vm.getUpdatedMezo())
                    parentVm.selectedMezo = vm.selectedMezo
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
        }
        .sheet(isPresented: $vm.isShowingSheet) {
            
            if vm.isShowingEditPhases {
                EditPhasesListView( mezo: $vm.selectedMezo, phases: $vm.selectedMezo.phases)

            } else {
                AddPhasesToMezoListView( mezo: $vm.selectedMezo, phases: $vm.phases)
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



struct EditMezocycleHeaderForm: View{
    @State private var textFields: [String] = Array(repeating: "", count: 8)
    private let placeholders = ["Mezocycle Name", "Duration (in months)", "Training Focus", "Intensity", "Progression Strategy", "Total Trainings", "Description"]
    @ObservedObject var vm: EditMezocycleViewModel
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
            }
        }
    }
    
}
