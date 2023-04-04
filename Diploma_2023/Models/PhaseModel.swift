//
//  PhaseModel.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 30/03/2023.
//

import SwiftUI



//mutating func addPhase(phaseID: Int) {
//    let newIndex = loads.count
//    loads.append([]) // Add a new empty row to the loads 2D array
//    phaseIndices[phaseID] = newIndex // Update the phaseIndices mapping
//}
//
//func loadsForPhase(phaseID: Int) -> [Load]? {
//    if let index = phaseIndices[phaseID] {
//        return loads[index]
//    } else {
//        return nil
//    }
//}
//
//func addSet(repetitions: Int, weight: Int, to load: inout Load) {
//    let set = (repetitions: repetitions, weight: weight)
//    load.sets.append(set)
//}
//





struct PhaseMockNew: IdentifiableItemMock {
    
    // IdentifiableItem properties
    var id: Int
    var dataType: DataType { .phase }
    var title: String
    var subTitle: String
    var categoryIDs: [Int]
    var imageName = "peak-logo"
    var clientID: Int?

    
    // PHASE HEADER properties
    var clientName: String
    var phase: String
    var periodization: String
    var integrationGoal: String
    
    
    // SHEET PROPERTIES
    var sheetRowIDs: [Int]
    var trainingSessions: [TrainingSessionMock]
    // ... other properties and methods
}


struct SheetRowMock: Identifiable{
    var id: Int
    var exerciseID: Int
    var exerciseName: String
    var clientID: Int
    var exerciseSettings: [ExerciseSettingsMock]
    var loads: [[LoadMock]] // 2D array where each row represents a phase, and each column represents a training session
    var loadsStrings:[String]

    var phaseIndices: [Int: Int] // Maps phase IDs to their corresponding index in the loads 2D array
}

struct ExerciseSettingsMock {
    var phaseID: Int
    var tempo: String
    var rep: String
    var set: String
    var rest: String
    var micro: String
}

struct TrainingSessionMock {
    var sessionIndex: Int
    var date: Date
    var volume: Double
    var percentIncrease: Double
    // ... other aggregated properties
}

typealias RepsWeightTuple = (repetitions: Int, weight: Int)

struct LoadMock {
    var date: Date
    var sets: [RepsWeightTuple]
}


