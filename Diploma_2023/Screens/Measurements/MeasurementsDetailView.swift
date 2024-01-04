//
//  MeasurementsDetailView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 03/10/2023.
//

import SwiftUI
import Combine
import UIKit

// MARK: - Measurements Detail - ViewModel
class MeasurementsDetailViewModel: ObservableObject {
    @Published var selectedMeasurements: Measurements
    @Published var dataWasChanged = false
    @Published var isEditing = false
    @Published var showSavedMessage: Bool = false

    
    
    private var autoSaveTimer: Timer?
    private var cancellables: Set<AnyCancellable> = []
    
    
    // Clients
    private let clientsDataStore: ClientsDataStore
    
    init(selectedMeasurements: Measurements,
         clientsDataStore: ClientsDataStore = AppDependencyContainer.shared.clientsDataStore
    ) {
        
        // Selected item passed from Measurements
        self.selectedMeasurements = selectedMeasurements
        
        // Client Data Stores
        self.clientsDataStore = clientsDataStore
        
        
        

        
        // Listen for changes in dataWasChanged
        $dataWasChanged
            .sink { [weak self] changed in
                if changed {
                    
                    print("TIMER TRIGGER \n data was changed: \(changed)")
                    
                    self?.recalculate()
                    self?.setUpAutoSaveTimer()  // Call your function that sets up the timer
                }
            }
            .store(in: &cancellables)
    }

    
    
    
    
    // Method to invalidate the timer
    public func invalidateAutoSaveTimer() {
        autoSaveTimer?.invalidate()
    }
    
    private func setUpAutoSaveTimer() {
        print("Setting up new timer")
        autoSaveTimer?.invalidate()  // Invalidate any existing timer
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
            if let self = self, self.dataWasChanged {
                self.updateMeasurement(newMeasurements: self.selectedMeasurements)
                self.dataWasChanged = false
                
                // Show saved message
                self.showSavedMessage = true
                
                // Hide saved message after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.showSavedMessage = false
                }
                
            }
        }
    }
    
    func showSavedStatus() {
        self.showSavedMessage = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.showSavedMessage = false
        }
    }
    
    func recalculate(){
        print(" \n RECALCULATE \n ")
        self.selectedMeasurements.recalculateAllRatings(gender: "w")
    }
    
    func updateMeasurement(newMeasurements: Measurements) {
        var updatedMeasurements = newMeasurements
        updatedMeasurements.prepareAllForSave()
        
        clientsDataStore.updateMeasurements(measurements: updatedMeasurements) { result in
            // Handle result or error
        }
    }

}
    
    
// MARK: - Measurements Detail - View

struct MeasurementsDetailView: View, DetailView {
    
    @ObservedObject private var vm: MeasurementsDetailViewModel


    init(item: IdentifiableItem) {

        print("INNIT MEASUREMENTS")
        self.vm = MeasurementsDetailViewModel(selectedMeasurements: item as! Measurements)
        

    }
    
    var body: some View {

        ScrollView(.horizontal, showsIndicators: true) {
            ScrollView(.vertical, showsIndicators: true) {
                MeasurementSheetTable(vm: vm)
                    .font(.caption)
            }
        }
        
        .navigationBarTitle(vm.selectedMeasurements.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if vm.dataWasChanged {
                    Button(action: {
                        vm.updateMeasurement(newMeasurements: vm.selectedMeasurements)
                        vm.dataWasChanged = false
                        vm.invalidateAutoSaveTimer()  // Invalidate the timer when manually saving
                        
                        // recalculate
                        vm.recalculate()
                        
                        // Show saved message
                        vm.showSavedStatus()
                        
                    }) {
                        Text("Save")
                    }
                }
                
                if vm.showSavedMessage {
                    Button {
                    } label: {
                        Text("Saved!")
                    }

                    
                }
            }
        }
    }
        
}

// MEASUREMENTS TABLE (SHEET) = HEADER + CONTENT
struct MeasurementSheetTable: View {
    @ObservedObject var vm: MeasurementsDetailViewModel // Your ViewModel
    
    var body: some View {
        VStack(spacing: 0){
            // LABEL HEADER
            SheetHeaderBuilder(
                labels: Measurement.Constants.SheetTable.sheetLabels,
                uniformWidth: Measurement.Constants.SheetTable.cellsWidth,
                height: Measurement.Constants.SheetTable.heightHeader,
                color: Color.secondary)
            
            //  UNITS HEADER
            SheetHeaderBuilder(
                labels: Measurement.Constants.SheetTable.sheetLabelsUnits,
                uniformWidth: Measurement.Constants.SheetTable.cellsWidth,
                height: Measurement.Constants.SheetTable.heightHeader/2,
                color: Color.secondary,
                textColor: Color.secondary)
            
            // TABLE
            MeasurementTableContentBuilder(
                isModified: $vm.dataWasChanged,
                measurements: $vm.selectedMeasurements.measurements,
                width: Measurement.Constants.SheetTable.cellsWidth,
                height: Measurement.Constants.SheetTable.heightContent,
                color: Color.gray.opacity(0.1),
                borderColor: Color.primary.opacity(0.1),
                borderWidth: 0.4)
        }
    }
}

// MEASUREMENTS TABLE (SHEET) - CONTENT
struct MeasurementTableContentBuilder: View {
    @Binding var isModified: Bool
    @Binding var measurements: [Measurement]
    var width: CGFloat
    var height: CGFloat
    var color: Color
    
    var borderColor: Color?
    var borderWidth: Double?
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(measurements.indices, id: \.self) { index in
                MeasurementRowBuilder(
                    isModified: $isModified,
                    measurement: $measurements[index],
                    width: width,
                    height: height,
                    color: color,
                    borderColor: borderColor,
                    borderWidth: borderWidth)
            }
        }
    }
}

// MEASUREMENTS TABLE (SHEET) - CONTENT - 1 ROW
struct MeasurementRowBuilder: View {
    @Binding var isModified: Bool
    @Binding var measurement: Measurement

    var width: CGFloat
    var height: CGFloat
    var color: Color
    var borderColor: Color?
    var borderWidth: Double?

    
    
    var body: some View {
        HStack(spacing: 0) {
                
            // INFO COLUMNS
            HStack(spacing: 0) {
                // Date
                TextFieldCellBuilder(textBinding: $measurement.date, width: width, height: height*2, color: color, borderWidth: borderWidth, borderColor: borderColor)
                
                // Age
                TextFieldCellBuilder(textBinding: $measurement.age, width: width, height: height*2, color: color, borderWidth: borderWidth, borderColor: borderColor)
                
                // Height
                TextFieldCellBuilder(textBinding: $measurement.height, width: width, height: height*2, color: color, borderWidth: borderWidth, borderColor: borderColor)
                
                // Weight
                TextFieldCellBuilder(textBinding: $measurement.weight, width: width, height: height*2, color: color, borderWidth: borderWidth, borderColor: borderColor)
                
                // Lean Mass - computed
                StaticTextCellBuilder(text: measurement.leanMass.map { String(format: "%.2f", $0) }, width: width, height: height*2, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)

                // Bodyfat - computed
                StaticTextCellBuilder(text: measurement.bodyfat.map { String(format: "%.2f", $0) }, width: width, height: height*2, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
            }
            
            
            // MEASUREMENTS COLUMNS
            HStack(spacing: 0) {
                // The rest of the measurements
                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.chin, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingChin.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.cheek, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingCheek.map { String( $0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.pec, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingPec.map { String( $0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.triceps, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingTriceps.map { String( $0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.subscap, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingSubscap.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.midAx, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingMidAx.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.suprailiac, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingSuprailiac.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }
            }
                        
            HStack(spacing: 0) {
                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.umbilical, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingUmbilical.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.knee, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingKnee.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }
                
                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.calve, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingCalve.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.quad, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingQuad.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }
                
                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.hamstring, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingHamstring.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                VStack(spacing: 0){
                    TextFieldCellBuilder(textBinding: $measurement.biceps, width: width, height: height, color: color ,modified: $isModified, borderWidth: borderWidth, borderColor: borderColor)
                    StaticTextCellBuilder(text: measurement.ratingBiceps.map { String($0) }, width: width, height: height, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
                }

                // SUM - computed
                StaticTextCellBuilder(text: measurement.sumOfMeasurements.map { String(format: "%.2f", $0) }, width: width, height: height*2, color: color, textColor: .secondary, borderWidth: borderWidth, borderColor: borderColor)
            }
            



            



            
            
        }
        .overlay(
            Rectangle()
                .fill(Color.secondary)
                .frame(height: 1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        )
    }
}
