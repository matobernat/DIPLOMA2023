//
//  Builders.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 22/03/2023.
//

import SwiftUI



// CELL BUILDER - STATIC BINDIND
struct StaticBindingCellBuilder: View {
    var textBinding: Binding<String>
    
    var width: CGFloat
    var height: CGFloat
    var color: Color

    var body: some View {
        Text(textBinding.wrappedValue)
            .frame(width: width, height: height)
            .background(color)
            .border(Color.gray, width: 1)
    }
}

// CELL BUILDER - STATIC TEXT
struct StaticTextCellBuilder: View {
    var text: String
    
    var width: CGFloat
    var height: CGFloat
    var color: Color

    var body: some View {
        Text(text)
            .frame(width: width, height: height)
            .background(color)
            .border(Color.gray, width: 1)
    }
}

// CELL BUILDER - TEXT FIELD BINDING
struct TextFieldCellBuilder: View {
    var textBinding: Binding<String>
    
    var width: CGFloat
    var height: CGFloat
    var color: Color
    
    var body: some View {
        CustomTextEditorCell(textBinding: textBinding,
                             width: width,
                             height: height,
                             color: color)
    }
    
}

// UNIVERSAL - HEADER
struct SheetHeaderBuilder: View {
    var labels: [String]
    var width: [CGFloat]
    var height: CGFloat
    var color: Color

    var body: some View {
        HStack(spacing: 0) {
            ForEach(labels.indices, id: \.self) { index in
                StaticTextCellBuilder( text: labels[index], width: width[index], height: height, color: color)
            }
        }
    }
}



struct addPhaseToClientSheet: View {
    @ObservedObject var vm: PhaseSheetViewModel
    @Binding var clients: [Client]
    @Binding var phase: Phase
    @State var searchText = ""

    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                

                
                List(selectedItemsSearch(allItems: clients, selectedCategory: nil, searchText: searchText)) { client in
                    
                    HStack {
                        Text(client.title)
                        Spacer()
                        Button {
                            // Action to perform when the button is tapped
                            vm.addPhaseToClient(phase: phase, client: client)
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.mini)
                        .tint(.accentColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                
                
            }
            .navigationBarTitle("Add Exercises", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        vm.isShowingClientList = true
                        vm.isShowingSheet = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        vm.isShowingClientList = true
                        vm.isShowingSheet = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                    }
                }
            }
        }
    }
}



// PHASES - ADD EXERCISES LIST
struct AddExercisesPhaseView: View {
    //    @ObservedObject var vm: PhaseSheetViewModel
    @Binding var exercises: [Exercise]
    @Binding var phase: Phase
    @State var selectedSheetRows = [SheetRow]()
    @State var searchText = ""

    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                SearchBar(searchText: $searchText)
                    .padding(.horizontal)
                List(selectedItemsSearch(allItems: exercises, selectedCategory: nil, searchText: searchText)) { exercise in
                    AddExerciseToPhaseItem( selectedSheetRows: $selectedSheetRows, exercise: exercise)
                }
            }
            .navigationBarTitle("Add Exercises", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        selectedSheetRows.removeAll()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        phase.sheetRows += selectedSheetRows
                        selectedSheetRows.removeAll()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                    }
                }
            }
        }
    }
}


//  PHASES - ADD EXERCISE ITEM
struct AddExerciseToPhaseItem: View {
    @State private var isChecked = false
    @Binding var selectedSheetRows: [SheetRow]
    let exercise: Exercise

    var body: some View {
        HStack {
            Text(exercise.title)
            Spacer()
            
            // Add or Remove item
            Button(action: {
                isChecked ? selectedSheetRows = selectedSheetRows.filter { $0.exerciseID != exercise.id } :
                             selectedSheetRows.append(SheetRow(exerciseID: exercise.id, exerciseName: exercise.title, exerciseSettings: ExerciseSettings.getNew()))
                isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "minus" : "plus.circle")
            }
        }
    }
}


// EXERCISES - EDIT
struct EditExersiseListPhase: View {
    @Binding var phase: Phase
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ZStack{

                List {
                    ForEach(phase.sheetRows, id: \.self) { sheetRow in
                        HStack {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    if let index = phase.sheetRows.firstIndex(of: sheetRow) {
                                        phase.sheetRows.remove(at: index)
                                    }
                                }
                            Text(sheetRow.exerciseName)
                            Spacer()
                            Image(systemName: "line.horizontal.3")
                                .foregroundColor(.gray)
                        }
                    }
                    .onMove { indices, newOffset in
                        phase.sheetRows.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Edit Exercises", displayMode: .inline)
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
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Done")
                        }
                    }
                }

                if phase.sheetRows.isEmpty {
                    Color(.systemGray6)
                        .ignoresSafeArea()
                    VStack {
                        Text("Empty Exercise List")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}



