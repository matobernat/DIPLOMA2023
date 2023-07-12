//
//  PhaseSheetView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 21/02/2023.
//

import SwiftUI
import Combine

// MARK: - PhaseSheet - ViewModel
class PhaseSheetViewModel: ObservableObject {
    
    
    // TABLE SETTINGS + LABELS

    var heightInfoTable: CGFloat = 50
    var widthInfoTable: [CGFloat] {
        if isEditing {
            return [150,150,150,150,150,150]
        } else {
            return [200,200,200,200,200]
        }
    }
    var phaseInfoTableHeaderLabels: [String] {
        if isEditing{
            return ["PHASE NAME", "DURATION - IN WEEKS", "PHASE", "PERIODIZATION", "INTEGRATION GOAL"]
        }
        return ["CLIENT NAME", "PHASE", "PERIODIZATION", "INTEGRATION GOAL"]
    }
    
    var heightSheetTableHeader: CGFloat = 50
    var heightSheetTableContent: CGFloat = 80
    var widthsSheetTable: [CGFloat] {
        if isEditing {
            return [200, 120, 120, 120, 120, 120]
        } else {
            return [200, 80, 80, 80, 80, 80, 130, 130, 130, 130]
        }
    }
    var phaseSheetTableHeaderExerciseSettingsLabels: [String] {
        return ["Exercise", "Tempo", "Rep", "Set", "Rest", "Micro"]
    }
    func phaseSheetTableHeaderLoadLabels(numberOfLoads: Binding<Int>) -> [String] {
        let count = numberOfLoads.wrappedValue
        return (1...count).map { "Load \($0)" }
    }
    
    
    
    private let phasesDataStore: PhasesDataStore
    @Published var selectedPhase:Phase
    private let clientsDataStore: ClientsDataStore
    @Published var clients:[Client]
    
    @Published var isEditing = false
    @Published var isShowingSheet: Bool = false
    @Published var isShowingEditExercises: Bool = false
    @Published var isShowingClientList: Bool = false

    
    @Published var searchText = ""


    private let exercisesDataStore: ExercisesDataStore
    @Published var exercises: [Exercise] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(selectedPhase: Phase, selectedClient: Client? = nil) {
        
        
        self.phasesDataStore = AppDependencyContainer.shared.phasesDataStore
        self.selectedPhase = selectedPhase
        self.clientsDataStore = AppDependencyContainer.shared.clientsDataStore
        self.clients = clientsDataStore.allClients
        
        
        // EXERCISES MANAGEMENT
        self.exercisesDataStore = AppDependencyContainer.shared.exercisesDataStore
        self.exercises = exercisesDataStore.allExercises
        // Subscribe to changes in Exercises
        exercisesDataStore.$allExercises.sink { [weak self] newExercises in
            self?.exercises = newExercises
        }
        .store(in: &cancellables)
        
        clientsDataStore.$allClients.sink { [weak self] newClients in
            self?.clients = newClients
        }
        .store(in: &cancellables)
        
    }
    

//MARK: CRUD operations
    func addPhaseToClient(phase: Phase, client: Client){
        
        var newClient = client
        var newPhase = phase
        if phase.clientID == nil{
            if phase.mezocycleID == nil{
                newPhase = newPhase.duplicate().setClientID(clientID: client.id, clientName: client.title)
                newClient = newClient.addPhase(phase: newPhase)
            }else{
                newPhase = newPhase.duplicate().clearMezoID().setClientID(clientID: client.id, clientName: client.title)
                newClient = newClient.addPhase(phase: newPhase)
            }
        }
        else{
            newPhase = newPhase.clientID == client.id ? newPhase.setNewName(existingTitles: client.phases.map { $0.title }) : newPhase.setNewName(existingTitles: [])
            if phase.mezocycleID == nil{
                newPhase = newPhase.duplicate().setClientID(clientID: client.id, clientName: client.title)
                newClient = newClient.addPhase(phase: newPhase)
            }else{
                newPhase = newPhase.duplicate().clearMezoID().setClientID(clientID: client.id, clientName: client.title)
                newClient = newClient.addPhase(phase: newPhase)
            }
            
        }
        AppDependencyContainer.shared.clientsDataStore.updateClient(newClient) { result in
            // handle error
        }
    }
    
    
    // duplicate phase, within client or mezocycle
    func duplicatePhase(selectedPhase: Phase){
        var newPhase = selectedPhase.duplicate()
        if selectedPhase.mezocycleID == nil{
            if selectedPhase.clientID == nil{
                phasesDataStore.createPhase(newPhase.setNewName(existingTitles: AppDependencyContainer.shared.phasesDataStore.allPhases.map { $0.title })){ result in
                    //handle result
                }
            }
            else{
                if var newClient = AppDependencyContainer.shared.clientsDataStore.getClient(clientID: newPhase.clientID) {
                    let updatedPhase = newPhase.setNewName(existingTitles: newClient.phases.map { $0.title })
                    newClient = newClient.addPhase(phase: updatedPhase)
                    AppDependencyContainer.shared.clientsDataStore.updateClient(newClient) { result in
                        // Handle result
                    }
                }
            }
        }
        else{
            if selectedPhase.clientID == nil{
                if var newMezo = AppDependencyContainer.shared.mezoDataStore.getMezo(mezoID: selectedPhase.mezocycleID){
                    newMezo = newMezo.addPhase(phase: newPhase.setNewName(existingTitles: newMezo.phases.map {$0.title}))
                    AppDependencyContainer.shared.mezoDataStore.updateMezo(newMezo) { result in
                        // Handle result
                    }
                }
            }
            else{
                if var newClient = AppDependencyContainer.shared.clientsDataStore.getClient(clientID: newPhase.clientID) {
                    if var newMezo = newClient.mezocycles.first(where: { $0.id == newPhase.mezocycleID }){
                        newPhase = newPhase.setNewName(existingTitles: newMezo.phases.map {$0.title})
                        newClient = newClient.updateMezo(mezo: newMezo.addPhase(phase: newPhase))
                        AppDependencyContainer.shared.clientsDataStore.updateClient(newClient) { result in
                            // Handle result
                        }
                    }
                   
                }
            }
        }
    }
    
    
    
    // 1. Update Phase, 2. if has mezocycleID update Mezo 3. If has clientID update client
    func updatePhase(selectedPhase: Phase) {
       
        if selectedPhase.clientID == nil{
            if selectedPhase.mezocycleID == nil{
                // case 1
                phasesDataStore.updatePhase(selectedPhase) { resule in
                    // Handle result
                }
            }
            else{
                // case 1 + 2
                if let selectedMezo = AppDependencyContainer.shared.mezoDataStore.getMezo(mezoID: selectedPhase.mezocycleID) {
                    AppDependencyContainer.shared.mezoDataStore.updateMezo(selectedMezo.updatePhase(phase:selectedPhase)) { result in
                        // handle error
                    }
                }
            }
        }else{
            // case 1 + 3
            if selectedPhase.mezocycleID == nil{
                if let selectedClient = AppDependencyContainer.shared.clientsDataStore.getClient(clientID: selectedPhase.clientID) {
                    AppDependencyContainer.shared.clientsDataStore.updateClient(selectedClient.updatePhase(phase:selectedPhase)) { result in
                        // handle error
                    }
                }
            }
            else{
                // case 1 + 2 + 3
                if let selectedClient = AppDependencyContainer.shared.clientsDataStore.getClient(clientID: selectedPhase.clientID) {
                    if let selectedMezo = selectedClient.getClientMezo(mezoID: selectedPhase.mezocycleID!) {
                        AppDependencyContainer.shared.clientsDataStore.updateClient(selectedClient.updateMezo(mezo: selectedMezo.updatePhase(phase: selectedPhase))) { result in
                            // handle error
                        }
                    }
                }
            }
            
        }
    }
        
    
    func deletePhase(selectedPhase:Phase){
        if selectedPhase.clientID == nil{
            if selectedPhase.mezocycleID == nil{
                phasesDataStore.deletePhase(selectedPhase) { resule in
                    // Handle result
                }
            }
            else{
                if let selectedMezo = AppDependencyContainer.shared.mezoDataStore.getMezo(mezoID: selectedPhase.mezocycleID) {
                    AppDependencyContainer.shared.mezoDataStore.updateMezo(selectedMezo.deletePhase(phaseID: selectedPhase.id)) { result in
                        // handle error
                    }
                }
            }
        }else{
            if selectedPhase.mezocycleID == nil{
                if let selectedClient = AppDependencyContainer.shared.clientsDataStore.getClient(clientID: selectedPhase.clientID) {
                    AppDependencyContainer.shared.clientsDataStore.updateClient(selectedClient.deletePhase(phaseID:selectedPhase.id)) { result in
                        // handle error
                    }
                }
            }
            else{
                if let selectedClient = AppDependencyContainer.shared.clientsDataStore.getClient(clientID: selectedPhase.clientID) {
                    if let selectedMezo = AppDependencyContainer.shared.mezoDataStore.getMezo(mezoID: selectedPhase.mezocycleID) {
                        AppDependencyContainer.shared.clientsDataStore.updateClient(selectedClient.updateMezo(mezo: selectedMezo.deletePhase(phaseID: selectedPhase.id))) { result in
                            // handle error
                        }
                    }
                }
            }
            
        }
    }

    
    func archivePhase(selectedPhase: Phase) {
        self.selectedPhase.categoryIDs = AppDependencyContainer.shared.categoryDataStore.getCategoryIDs(subStrings: ["Archived"], section: .trainingPlan)
        self.updatePhase(selectedPhase: self.selectedPhase)
    }
    
    
}




// MARK: - PhaseSheet - View
struct PhaseSheetView: View, DetailView {
    @Environment(\.presentationMode) var presentationMode

    
    @ObservedObject private var vm: PhaseSheetViewModel

    
    init(item: IdentifiableItem) {
        self.vm = PhaseSheetViewModel(selectedPhase: item as! Phase)
    }

    
    var body: some View {
        
        ScrollView{
            VStack(alignment: .center, spacing: 15){
                
                // INFO TABLE
                PhaseInfoTable(vm: vm)
                    .padding(.vertical, 20)
                
                if vm.isEditing{
                    // Add + Edit BUTTONS
                    buttonsView()
                        .padding(.horizontal, 20)
                    Divider()
                }

                
                // PHASE TABLE
                if vm.isEditing || vm.selectedPhase.clientID == nil {
                    PhaseSheetTable(vm: vm)
                }else{
                    ScrollView(.horizontal){
                        PhaseSheetTable(vm: vm)
                            .padding(.top, 30)
                    }
                }


                
            }
        }
        
        .navigationBarItems(trailing: Button(action: {
            // Empty action, button only used to present ContextMenu
        }, label: {
            Image(systemName: "ellipsis.circle") // This is the "more" button
        }).contextMenu {

            Button(action: {
                //addPhaseToClientSheet()
                presentationMode.wrappedValue.dismiss()
                vm.isShowingSheet = true
                vm.isShowingClientList = true
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
                vm.duplicatePhase(selectedPhase: vm.selectedPhase)
            }, label: {
                HStack{
                    Text("Duplicate")
                    Spacer()
                    Image(systemName: "doc.on.doc")
                }
                .foregroundColor(.red)
            })
            if vm.selectedPhase.clientID == nil {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    vm.archivePhase(selectedPhase: vm.selectedPhase)
                    // Call your function to delete the client here
                }, label: {
                    HStack{
                        Text("Archive")
                        Spacer()
                        Image(systemName: "archivebox")
                    }
                    .foregroundColor(.red)
                })
            }
            Button(role: .destructive) {
                presentationMode.wrappedValue.dismiss()
                vm.deletePhase(selectedPhase: vm.selectedPhase)
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
        
        .navigationTitle(vm.selectedPhase.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if vm.isEditing {
                    Button(action: {
                        vm.isEditing = false
                        vm.updatePhase(selectedPhase: vm.selectedPhase)
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
            
            if vm.isShowingEditExercises {
                EditExersiseListPhase(phase: $vm.selectedPhase)

            } else if vm.isShowingClientList{
                addPhaseToClientSheet(vm: vm, clients: $vm.clients, phase: $vm.selectedPhase)
            }
            else {
                AddExercisesPhaseView(exercises: $vm.exercises, phase: $vm.selectedPhase)
            }
        }
    }
    
    func buttonsView() -> some View {
        HStack {
            Button(action: {
                vm.isShowingEditExercises = false
                vm.isShowingSheet = true
            }) {
                Label("Add Exercises", systemImage: "plus.circle.fill")
                    .padding(.leading, 10)
            }
            
            Spacer()
            
            Button(action: {
                vm.isShowingEditExercises = true
                vm.isShowingSheet = true
            }) {
                Label("Edit Exercises", systemImage: "slider.vertical.3")
                    .padding(.leading, 10)
                    .foregroundColor(.gray)
            }
        }
    }

}

// PHASE HEADER (INFO TABLE) WHOLE UI
struct PhaseInfoTable: View {
    @ObservedObject var vm: PhaseSheetViewModel

    // converting  properties of @Binding newPhase to @Binding array
    var data: Binding<[String]> {
        Binding<[String]>(
            get: {
                if vm.isEditing{
                   return [vm.isEditing ? vm.selectedPhase.phaseName : vm.selectedPhase.clientID != nil ? vm.selectedPhase.headerClientName : "TEMPLATE",
                        vm.selectedPhase.phaseDurationInWeeks,
                        vm.selectedPhase.headerPhaseInSeason,
                        vm.selectedPhase.headerPeriodizationTitle,
                        vm.selectedPhase.headerIntegrationGoal]
                }else{
                   return [vm.isEditing ? vm.selectedPhase.phaseName : vm.selectedPhase.clientID != nil ? vm.selectedPhase.headerClientName : "TEMPLATE",
                        vm.selectedPhase.headerPhaseInSeason,
                        vm.selectedPhase.headerPeriodizationTitle,
                        vm.selectedPhase.headerIntegrationGoal]
                }
            },
            set: { newValue in
                if vm.isEditing{
                    // Update the phase properties based on the new data
                    vm.selectedPhase.phaseName = newValue[0]
                    vm.selectedPhase.phaseDurationInWeeks = newValue[1]
                    vm.selectedPhase.headerPhaseInSeason = newValue[2]
                    vm.selectedPhase.headerPeriodizationTitle = newValue[3]
                    vm.selectedPhase.headerIntegrationGoal = newValue[4]
                }else{
                    vm.selectedPhase.phaseName = newValue[0]
                    vm.selectedPhase.phaseDurationInWeeks = newValue[1]
                    vm.selectedPhase.headerPeriodizationTitle = newValue[2]
                    vm.selectedPhase.headerIntegrationGoal = newValue[3]
                }

            }
        )
    }
        
    var body: some View {
            VStack(spacing: 0){
                SheetHeaderBuilder(
                    labels: Phase.Constants.InfoTable.headerLabels(isEditing: vm.isEditing),
                    width: Phase.Constants.InfoTable.width(isEditing: vm.isEditing),
                    height: Phase.Constants.InfoTable.height,
                                   color: Color.gray.opacity(0.2))
                infoTableRowBuilder()
            }
    }
    
    
    // INFO TABLE CONTENT
    func infoTableRowBuilder() -> some View {
        HStack(spacing: 0) {
            if vm.isEditing {
                ForEach(data.indices, id: \.self) { index in
                    TextFieldCellBuilder(textBinding: data[index],
                                         width: Phase.Constants.InfoTable.width(isEditing: vm.isEditing)[index],
                                         height: Phase.Constants.InfoTable.height,
                                         color: Color.white.opacity(0.2))
                }
            }
            else{
                ForEach(data.indices, id: \.self) { index in
                    StaticBindingCellBuilder(textBinding: data[index],
                                             width: Phase.Constants.InfoTable.width(isEditing: vm.isEditing)[index],
                                             height: Phase.Constants.InfoTable.height,
                                         color: Color.white.opacity(0.2))
                }
            }
        }
    }
    
}

// PHASE TABLE (SHEET) = HEADER + CONTENT
struct PhaseSheetTable: View {
    @ObservedObject var vm: PhaseSheetViewModel
    
    var body: some View {
        VStack(spacing: 0){
            
            // HEADER
            SheetHeaderBuilder(
                labels: vm.isEditing || vm.selectedPhase.clientID == nil ? vm.phaseSheetTableHeaderExerciseSettingsLabels: vm.phaseSheetTableHeaderExerciseSettingsLabels + vm.phaseSheetTableHeaderLoadLabels(numberOfLoads: $vm.selectedPhase.numberOfLoads),
                width: Phase.Constants.SheetTable.width(isEditing: vm.isEditing),
                height: Phase.Constants.SheetTable.heightHeader,
                               color: Color.secondary)
            
            // TABLE
            PhaseTableContentBuilder(
                                     isEditing: $vm.isEditing,
                                     phase: $vm.selectedPhase,
                                     widths: Phase.Constants.SheetTable.width(isEditing: vm.isEditing),
                                     height: Phase.Constants.SheetTable.heightContent,
                                     color: Color.white.opacity(0.1))
        }
    }
}

// PHASE TABLE (SHEET) - CONTENT
struct PhaseTableContentBuilder: View {
    @Binding var isEditing: Bool
    @Binding var phase: Phase
    var widths: [CGFloat]
    var height: CGFloat
    var color: Color

    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(phase.sheetRows.indices, id: \.self) { index in
                SheetRowBuilder(
                    clientID: $phase.clientID,
                    isEditing: $isEditing,
                    sheetRow: $phase.sheetRows[index],
                    phaseId: phase.id,
                    width: widths,
                    height: height,
                    color: color)
            }
        }
    }
}

// PHASE TABLE (SHEET) - CONTENT - 1 ROW
struct SheetRowBuilder: View {
    @Binding var clientID: String?
    @Binding var isEditing: Bool
    @Binding var sheetRow: SheetRow
    let phaseId : String
    
    var width: [CGFloat]
    var height: CGFloat
    var color: Color

    // converting  properties of @Binding newPhase.sheetRows[index] to @Binding array
    var data: Binding<[String]> {
        Binding<[String]>(
            get: { [sheetRow.exerciseSettings.tempo,
                    sheetRow.exerciseSettings.rep,
                    sheetRow.exerciseSettings.set,
                    sheetRow.exerciseSettings.rest,
                    sheetRow.exerciseSettings.micro] },
            set: { newValue in
                // Update the phase properties based on the new data
                sheetRow.exerciseSettings.tempo = newValue[0]
                sheetRow.exerciseSettings.rep = newValue[1]
                sheetRow.exerciseSettings.set = newValue[2]
                sheetRow.exerciseSettings.rest = newValue[3]
                sheetRow.exerciseSettings.micro = newValue[4]
            }
        )
    }
    
    
    // (This Struct may have some indexing error in the future)
    var body: some View {
        HStack(spacing: 0) {
            
            // Exercise Name
            StaticTextCellBuilder(text: sheetRow.exerciseName, width: width[0], height: height, color: color)

            // Exercise Settings
            ForEach(data.indices, id: \.self) { index in
                if isEditing{
                    TextFieldCellBuilder(textBinding: data[index], width: width[index+1], height: height, color: color)
                }
                else{
                    StaticBindingCellBuilder(textBinding: data[index], width: width[index+1], height: height, color: color)

                }
            }
            
//            if isEditing{
//
//            }
            

            // LOADS
            if !isEditing &&  clientID != nil {
                ForEach($sheetRow.allLoadsPerPhase.indices, id: \.self) { index in
                    TextFieldCellBuilder(textBinding: $sheetRow.allLoadsPerPhase[index].loadString,
                                         width: width[index + data.count+1],
                                         height: height,
                                         color: color)
                }
            }

        }
    }
}

