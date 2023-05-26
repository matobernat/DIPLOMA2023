//
//  NewPhaseView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 20/05/2023.
//

import SwiftUI

// MARK: - NewPhase - ViewModel
class NewPhaseTemplateViewModel: ObservableObject {
    
    @Published var newPhase:Phase
    
    
    var categories: [Category]
    var selectedCategory: Category
    var loggedAccount: Account
    
    init(categories: [Category], selectedCategory: Category, loggedAccount: Account) {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.loggedAccount = loggedAccount
        
    
        self.newPhase = Phase(
            categoryIDs: [],
            dateOfCreation: .now,
            accountID: loggedAccount.id,
            profileID: loggedAccount.id,
            phaseName: "",
            phaseDurationInWeeks: "",
            headerClientName: "",
            headerPhaseInSeason: "",
            headerPeriodizationTitle: "",
            headerIntegrationGoal: "",
            sheetRows: [SheetRow](),
            trainingSessions: [TrainingSession]()
        )
    }
}


// MARK: - NewPhase - View
struct NewPhaseTemplateView: View {
    @Environment(\.presentationMode) var presentationMode

    
    @ObservedObject private var parentVm: TrainingPlansViewModel
    @ObservedObject private var vm: NewPhaseTemplateViewModel
    @State var inSeasonBool: Bool = false
    
    init( parentVm: TrainingPlansViewModel) {
        self.parentVm = parentVm
        self.vm = NewPhaseTemplateViewModel(categories: parentVm.categories,
                                     selectedCategory: parentVm.selectedCategory!,
                                     loggedAccount: parentVm.loggedAccount!)
        
    }
    
    
    @State private var showAddMusicSheet = false

    var body: some View {
        NavigationStack{
            
            Form {
                Section(header: Text("Phase Information")) {
                    TextField("Phase Name", text: $vm.newPhase.phaseName)
                    TextField("Duration (in weeks)", text: $vm.newPhase.phaseDurationInWeeks).keyboardType(.numberPad)
//                    TextField("Client Name", text: $vm.newPhase.headerClientName)
                    TextField("Phase Number", text: $vm.newPhase.headerPhaseInSeason).keyboardType(.numberPad)
                }
                
                Section(header: Text("Phase Details")) {
                    Toggle("Phase in Season", isOn: $inSeasonBool)
                    TextField("Periodization Title", text: $vm.newPhase.headerPeriodizationTitle)
                    TextField("Integration Goal", text: $vm.newPhase.headerIntegrationGoal)
                }
                
                
                Section(header: Text("Exercises")) {
                    ExerciseItemForm()


                    Button(action: {
                        // Handle Add Exercise button action
                    }) {
                        Label("Add Exercises", systemImage: "plus.circle.fill")
                    }
                }
                
                
                
            }
            .navigationTitle("New Phase Template")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()

                        // Handle cancel action
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        presentationMode.wrappedValue.dismiss()

                        // Handle save action
                    }
                }
            }
            .sheet(isPresented: $showAddMusicSheet) {
                AddMusicView()
            }
        }
    }
}


struct AddMusicView: View {
    var body: some View {
        Text("Add Music")
    }
}


struct SongSelectionView: View {
    var body: some View {
        Text("Song Selection View")
            .navigationTitle("Select Songs")
    }
}


import SwiftUI

struct ContentView: View {
    @State private var showCarSection = true

    var body: some View {
                Section(header: Text("Car")
                            .overlay(
                                Button(action: {
                                    showCarSection.toggle()
                                }) {
                                    Text(showCarSection ? "Hide" : "Show")
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            )
                ) {
                    if showCarSection {
                        TextField("Year", text: .constant(""))
                        TextField("Brand", text: .constant(""))
                        TextField("Color", text: .constant(""))
                        TextField("Engine Size", text: .constant(""))
                    }
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




//struct NewPhaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewPhaseTemplateViewModel()
//    }
//}



//struct ExerciseItemForm: View{


//struct ExerciseItemForm: View {
//    @State private var isBoxed = true
//    @State private var exerciseName = "Exercise Name"
//    @State private var tempo = "Tempo"
//    @State private var rep = "Reps"
//    @State private var set = "Sets"
//    @State private var rest = "Rest"
//    @State private var micro = "Micro"
//}
struct ExerciseItemForm: View {
    @State private var isBoxed = false
    
    @State private var exerciseName = ""
    @State private var tempo = ""
    @State private var rep = ""
    @State private var set = ""
    @State private var rest = ""
    @State private var micro = ""
    
    var body: some View {
        VStack(spacing: 16) {
            if isBoxed {
                BoxedFormView(
                    isBoxed: $isBoxed,

                    exerciseName: $exerciseName,
                    tempo: $tempo,
                    rep: $rep,
                    set: $set,
                    rest: $rest,
                    micro: $micro
                )
            } else {
                UnboxedFormView(
                    isBoxed: $isBoxed,
                    exerciseName: $exerciseName,
                    tempo: $tempo,
                    rep: $rep,
                    set: $set,
                    rest: $rest,
                    micro: $micro
                )
            }
        }
    }
}

struct UnboxedFormView: View {
    @Binding var isBoxed: Bool
    @Binding var exerciseName: String
    @Binding var tempo: String
    @Binding var rep: String
    @Binding var set: String
    @Binding var rest: String
    @Binding var micro: String
    
    var body: some View {
        Button("Done") {
            isBoxed.toggle()
        }
        VStack {
             Section {
                 TextField("Exercise Name", text: $exerciseName)
                 TextField("Tempo", text: $tempo)
                 TextField("Reps", text: $rep)
                 TextField("Sets", text: $set)
                 TextField("Rest", text: $rest)
                 TextField("Micro", text: $micro)
             }
         }
        .background(Color.white)
    }
    
    private var separator: some View {
        Color(.systemGray)
            .frame(height: 1)
            .padding(.vertical, 8)
    }
}

//struct BoxedFormView: View {
//    var exerciseName: String
//    var tempo: String
//    var rep: String
//    var set: String
//    var rest: String
//    var micro: String
//    @Binding var isBoxed: Bool
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text("Exercise: \(exerciseName)")
//                Text("Tempo: \(tempo)")
//                Text("Reps: \(rep)")
//                Text("Sets: \(set)")
//                Text("Rest: \(rest)")
//                Text("Micro: \(micro)")
//            }
//            .foregroundColor(.gray)
//            .font(.subheadline)
//
//            Spacer()
//
//            Button("Edit") {
//                isBoxed.toggle()
//            }
//
//            Image(systemName: "line.horizontal.3")
//                .font(.system(size: 20))
//                .background(Color.gray.opacity(0.3))
//                .cornerRadius(10)
//        }
//        .padding()
//        .background(Color(.secondarySystemBackground))
//        .cornerRadius(10)
//    }
//}


struct BoxedFormView: View {
    @Binding var isBoxed: Bool
    @Binding var exerciseName: String
    @Binding var tempo: String
    @Binding var rep: String
    @Binding var set: String
    @Binding var rest: String
    @Binding var micro: String

    var body: some View {
        HStack {
            TextField("", text: $exerciseName)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    Text(exerciseName).foregroundColor(.gray),
                    alignment: .leading
                )
                .padding(.trailing)
            
            TextField("", text: $tempo)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    Text(tempo).foregroundColor(.gray),
                    alignment: .leading
                )
                .padding(.trailing)
            
            TextField("", text: $rep)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    Text(rep).foregroundColor(.gray),
                    alignment: .leading
                )
                .padding(.trailing)
            
            TextField("", text: $set)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    Text(set).foregroundColor(.gray),
                    alignment: .leading
                )
                .padding(.trailing)
            
            TextField("", text: $rest)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    Text(rest).foregroundColor(.gray),
                    alignment: .leading
                )
                .padding(.trailing)
            
            TextField("", text: $micro)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .overlay(
                    Text(micro).foregroundColor(.gray),
                    alignment: .leading
                )
            Spacer()
            
            Button("Edit") {
                isBoxed.toggle()
            }
        }
        .padding()
    }
}



