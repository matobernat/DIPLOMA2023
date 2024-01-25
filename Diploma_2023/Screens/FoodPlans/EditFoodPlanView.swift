//
//  EditFoodPlanView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 07/11/2023.
//

import SwiftUI

<<<<<<< HEAD

// MARK: - EditFoodPlan - View
struct EditFoodPlanView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var parentVm: FoodPlanDetailViewModel
    @StateObject var pdfEditViewModel: PDFEditViewModel // Initialized with UnifiedPage array

    
    private let originalUIPageData: [UnifiedPage]
    @State private var editableUIPageData: [UnifiedPage]  // State for editable data


    
    init( parentVm: FoodPlanDetailViewModel) {
        self.parentVm = parentVm
        self._editableUIPageData = State(initialValue: parentVm.selectedFoodPlanDataConverted) // Make a copy of the data
        self.originalUIPageData = parentVm.selectedFoodPlanDataConverted
        _pdfEditViewModel = StateObject(wrappedValue: PDFEditViewModel(pages: parentVm.selectedFoodPlanDataConverted))

//        self.getUpdatedData = getUpdatedData

    }
 

    
    
    var body: some View {
        NavigationStack{
            HStack{
                PDFContentView(status: $parentVm.selectedFoodPlan.status ,firebaseURL: $parentVm.selectedFoodPlan.firestoreDownloadURL)
//                PDFEditView(unifiedPages: $editableUIPageData) // Use editable copy
                PDFEditView(viewModel: pdfEditViewModel)
            }
        }
        .navigationTitle("Edit Food Protocol")
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
                    let updatedData = pdfEditViewModel.getCurrentData()
                    parentVm.selectedFoodPlanDataConverted = updatedData // Save changes to parentVm
                    parentVm.updateFoodPlan(selectedItem: parentVm.selectedFoodPlan, inputData: updatedData) // Save changes to parentVm
                    
//                    parentVm.selectedFoodPlanDataConverted = editableUIPageData // Save changes to parentVm
//                    parentVm.updateFoodPlan(selectedItem: parentVm.selectedFoodPlan, inputData: editableUIPageData ) // Save changes to parentVm
                    
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
        }
    }
}

=======
struct EditFoodPlanView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EditFoodPlanView_Previews: PreviewProvider {
    static var previews: some View {
        EditFoodPlanView()
    }
}
>>>>>>> main
