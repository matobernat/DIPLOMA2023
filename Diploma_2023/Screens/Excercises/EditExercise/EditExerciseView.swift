//
//  EditExerciseView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 01/05/2023.
//

import SwiftUI


struct EditExerciseView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var selectedExercise: Exercise
    @ObservedObject var vm: ExercisesViewModel
    @State var exercise: Exercise
    
    init(selectedExercise: Exercise, vm: ExercisesViewModel) {
        self.selectedExercise = selectedExercise
        self.vm = vm
        _exercise = State(initialValue: selectedExercise)
    }

    
    var body: some View {
            Form {
                
                Section(header: Text("Default Information")) {
                    TextField("Name", text: $exercise.title)
                    TextField("Description", text: $exercise.subTitle)
                    TextField("Youtube link", text: $exercise.link)
                }
                
                Section(header: Text("Exercise Information")) {
                    // Toggle Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Recovery", isOn: $exercise.recovery)
                        Text("Determine if is this exercise used for recovery")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    TextField("Body part", text: $exercise.bodyPart)
                    TextField("Base movement", text: $exercise.baseMovement)
                    TextField("difficulty", text: $exercise.difficulty)
                }
                
                
            }
                .navigationBarTitle(Text("Edit Exercise"))
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: {
                        print("cancel")
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text("Cancel")
                    },
                    trailing: Button(action: {
                        // Save the changes and dismiss the view
                        vm.updateExercise(selectedExercise: exercise)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                    }
                )
        
            
    }
}


