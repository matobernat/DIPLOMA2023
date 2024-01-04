//
//  NewPhaseSheetView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 21/05/2023.
//

import SwiftUI
import Combine

// MARK: - NewPhaseSheet - ViewModel
class NewPhaseSheetViewModel: ObservableObject {
    
    
    
    // TABLE SETTINGS + LABELS

    var heightInfoTable: CGFloat = 50
    var widthInfoTable: [CGFloat] = [200,200,200,200,200,200]
    // NOTE: - Here is phaseInfoTableHeaderLabels a bit different for Form purpouses
    var phaseInfoTableHeaderLabels: [String] { return ["PHASE NAME","DURATION - IN WEEKS", "PHASE", "PERIODIZATION", "INTEGRATION GOAL"]}

    var heightSheetTableHeader: CGFloat = 50
    var heightSheetTableContent: CGFloat = 80
    var widthsSheetTable: [CGFloat] = [200,160,160,160,160,160]
    var phaseSheetTableHeaderLabels: [String] {
        return ["Exercise", "Tempo", "Rep", "Set", "Rest", "Micro"]
    }
    
    
    @Published var newPhase:Phase
    @Published var selectedSheetRows = [SheetRow]() // this array is filled in sheet, based on "add" or "cancel" are added to newPhase
    @Published var isShowingSheet: Bool = false
    @Published var isShowingEditExercises: Bool = false
    @Published var searchText = ""
    
    var categories: [Category]
    var selectedCategory: Category
    var loggedAccount: Account

    
    private let exercisesDataStore: ExercisesDataStore
    @Published var exercises: [Exercise] = []
    private var cancellables = Set<AnyCancellable>()

    init(categories: [Category], selectedCategory: Category, loggedAccount: Account) {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.loggedAccount = loggedAccount
        
        self.newPhase = Phase(
            categoryIDs: AppDependencyContainer.shared.categoryDataStore.getCategoryIDs(selectedCategory: self.selectedCategory),
            dateOfCreation: .now,
            accountID: loggedAccount.id,
            profileID: loggedAccount.loggedProfile?.id ?? "",
            phaseName:"",
            phaseDurationInWeeks: "",
            headerClientName: "",
            headerPhaseInSeason: "",
            headerPeriodizationTitle: "",
            headerIntegrationGoal: "",
            sheetRows: [SheetRow](),
            trainingSessions: [TrainingSession]()
        )
        
        
        // EXERCISES MANAGEMENT
        self.exercisesDataStore = AppDependencyContainer.shared.exercisesDataStore
        self.exercises = exercisesDataStore.allExercises
        // Subscribe to changes in Exercises
        exercisesDataStore.$allExercises.sink { [weak self] newExercises in
            self?.exercises = newExercises
        }
        .store(in: &cancellables)
        
    }
    
    func updateSheetRows() {
        self.newPhase.sheetRows += self.selectedSheetRows
    }
    
}

// MARK: - NewPhaseSheet - View  (adding 4 loads each exercise)
struct NewPhaseSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var parentVm: TrainingPlansViewModel
    @ObservedObject private var vm: NewPhaseSheetViewModel
    
    
    init( parentVm: TrainingPlansViewModel) {
        self.parentVm = parentVm
        self.vm = NewPhaseSheetViewModel(categories: parentVm.categories,
                                     selectedCategory: parentVm.selectedCategory!,
                                     loggedAccount: parentVm.loggedAccount!)
        
    }

    
    var body: some View {
        ScrollView{
            VStack(alignment: .center, spacing: 15){
                
                // INFO TABLE
                NewPhaseInfoTable(labels: vm.phaseInfoTableHeaderLabels,
                                  newPhase: $vm.newPhase,
                                  height: vm.heightInfoTable,
                                  width: vm.widthInfoTable)

                // Add + Edit BUTTONS
                buttonsView()
                    .padding(.horizontal, 50)
                Divider()
                
                // PHASE TABLE
                NewPhaseSheetTable(newPhase: $vm.newPhase,
                                   headerLabels: vm.phaseSheetTableHeaderLabels,
                                   headerHeight: vm.heightSheetTableHeader,
                                   height: vm.heightSheetTableContent,
                                   widths: vm.widthsSheetTable)
                
            }
        }
        .navigationTitle("New Phase")
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
                    parentVm.addPhase(newPhase: vm.newPhase)
                    presentationMode.wrappedValue.dismiss()
                    print("SAVE")
                }) {
                    Text("Save")
                }
            }
        }
        .sheet(isPresented: $vm.isShowingSheet) {
            
            if vm.isShowingEditExercises {
                EditExersiseListPhase(phase: $vm.newPhase)

            } else {
                AddExercisesPhaseView(exercises: $vm.exercises, phase: $vm.newPhase)
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
struct NewPhaseInfoTable: View {
    var labels: [String]
    @Binding var newPhase: Phase
    var height: CGFloat
    var width: [CGFloat]
    
    
    // converting  properties of @Binding newPhase to @Binding array
    var data: Binding<[String]> {
        Binding<[String]>(
            get: { [newPhase.phaseName,
                    newPhase.phaseDurationInWeeks,
                    newPhase.headerPhaseInSeason,
                    newPhase.headerPeriodizationTitle,
                    newPhase.headerIntegrationGoal] },
            set: { newValue in
                // Update the phase properties based on the new data
                newPhase.phaseName = newValue[0]
                newPhase.phaseDurationInWeeks = newValue[1]
                newPhase.headerPhaseInSeason = newValue[2]
                newPhase.headerPeriodizationTitle = newValue[3]
                newPhase.headerIntegrationGoal = newValue[4]
            }
        )
    }

    var body: some View {
            VStack(spacing: 0){
                SheetHeaderBuilder(labels: labels, widths: width, height: 50, color: Color.gray.opacity(0.2))
                infoTableRowBuilder()
            }
    }
    
    func infoTableRowBuilder() -> some View {
        HStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
                TextEditorCellBuilder(textBinding: data[index], width: width[index ], height: height, color: Color.white.opacity(0.2))

            }
        }
    }
    
}

// PHASE TABLE (SHEET) = HEADER + CONTENT
struct NewPhaseSheetTable: View {
    
    @Binding var newPhase: Phase
    var headerLabels: [String] // ExerciseSettingsLabels + loadLabels
    var headerHeight:CGFloat
    var height: CGFloat
    var widths: [CGFloat]
    
    
    var body: some View {
//        ScrollView(.horizontal){    // not needed now, table is shorter without load
            VStack(spacing: 0){
                
                // HEADER
                SheetHeaderBuilder(labels: headerLabels, widths: widths, height: headerHeight, color: Color.secondary)
                
                // TABLE
                newPhaseTableContentBuilder(newPhase: $newPhase, widths: widths, height: height, color: Color.white.opacity(0.1))
            }
//        }
    }
}


// PHASE TABLE (SHEET) - CONTENT
struct newPhaseTableContentBuilder: View {
    @Binding var newPhase: Phase
    var widths: [CGFloat]
    var height: CGFloat
    var color: Color
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(newPhase.sheetRows.indices, id: \.self) { index in
                NewSheetRowBuilder(
                    newSheetRow: $newPhase.sheetRows[index],
                    width: widths,
                    height: height,
                    color: color)
            }
        }
    }
}

// PHASE TABLE (SHEET) - CONTENT - 1 ROW
struct NewSheetRowBuilder: View {
    
    @Binding var newSheetRow: SheetRow
    var width: [CGFloat]
    var height: CGFloat
    var color: Color

    // converting  properties of @Binding newPhase.sheetRows[index] to @Binding array
    var data: Binding<[String]> {
        Binding<[String]>(
            get: { [newSheetRow.exerciseSettings.tempo,
                    newSheetRow.exerciseSettings.rep,
                    newSheetRow.exerciseSettings.set,
                    newSheetRow.exerciseSettings.rest,
                    newSheetRow.exerciseSettings.micro] },
            set: { newValue in
                // Update the phase properties based on the new data
                newSheetRow.exerciseSettings.tempo = newValue[0]
                newSheetRow.exerciseSettings.rep = newValue[1]
                newSheetRow.exerciseSettings.set = newValue[2]
                newSheetRow.exerciseSettings.rest = newValue[3]
                newSheetRow.exerciseSettings.micro = newValue[4]
            }
        )
    }
    
    
    // (This Struct may have some indexing error in the future)
    var body: some View {
        HStack(spacing: 0) {
            
            // Exercise Name
            StaticTextCellBuilder(text: newSheetRow.exerciseName, width: width[0], height: height, color: color)

            // Exercise Settings
            ForEach(data.indices, id: \.self) { index in
                TextEditorCellBuilder(textBinding: data[index], width: width[index+1], height: height, color: color)
            }
        }
    }
}
