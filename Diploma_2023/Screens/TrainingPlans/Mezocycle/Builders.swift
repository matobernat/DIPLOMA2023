//
//  Builders.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 26/03/2023.
//

import SwiftUI




//
//// PHASES - EDIT
//struct EditPhasesListView: View {
//    @Binding var mezo: Mezocycle
//    @Binding var phases:[Phase]
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationStack {
//            SelectiveGridListViewEdit(
//                items: phases,
//                createCardView: { item in AnyCardView(LargeCardView(item: item)) },
//                createDetailView:{ item in AnyDetailView(TrainingPlanDetailView(item: item)) },
//                selectedItems: $mezo.phases,
//                parentItem: $mezo)
//        }
//        .navigationBarTitle("Edit Phases", displayMode: .inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Text("Cancel")
//                }
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Text("Done")
//                }
//            }
//        }
//    }
//}
//





// MEZOCYCLE - ADD PHASE ITEM LIST
struct AddPhasesToMezoListView: View {
    @ObservedObject var vm: TrainingPlansViewModel
    @Binding var mezo: Mezocycle
    @Binding var phases: [Phase]
    @State var selectedPhases = [Phase]()

    @State var searchText = ""
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment: .leading) {
                SelectiveGridListViewAdd(
                    items: phases,
                    createCardView: { item in AnyCardView(LargeCardView(item: item)) },
                    createDetailView:{ item in AnyDetailView(TrainingPlanDetailView(item: item)) },
                    selectedItems: $selectedPhases,
                    parentItem: $mezo)
    
                    .navigationBarTitle("Add Phases", displayMode: .inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                selectedPhases.removeAll()
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                mezo.phases += selectedPhases
                                selectedPhases.removeAll()
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Done")
                            }
                        }
                    }
            }
        }
    }
}


// MEZOCYCLE - ADD PHASE ITEM
struct AddPhaseToMezoItem: View {
    @State private var isChecked = false
    @Binding var selectedPhases: [Phase]
    let selectedPhase: Phase
    let newMezo: Mezocycle

    var body: some View {
        HStack {
            Text(selectedPhase.title)
            Spacer()
            
            // Add or remove item
            Button(action: {
                isChecked ? selectedPhases = selectedPhases.filter { $0.id != selectedPhase.id } : selectedPhases.append(selectedPhase.setMezo(mezoID: newMezo.id))
                isChecked.toggle()
                    
            }) {
                Image(systemName: isChecked ? "minus" : "plus.circle")
            }
        }
    }
}




