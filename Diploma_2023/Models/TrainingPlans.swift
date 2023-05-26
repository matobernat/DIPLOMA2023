//
//  TrainingPlans.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/05/2023.
//

import Foundation


// MARK: - Mezocycle,Phase,Exercise,SheetRow,ExerciseSettings,Load,RepsWeights


struct Mezocycle: IdentifiableItem,Identifiable, Hashable, Encodable, Decodable {
    var id = UUID().uuidString // fireBase UID
    var dataType: DataType { .mezocycle }
    var title: String
    var subTitle: String{
        return "\(durationInMonths) months"
    }
    var categoryIDs: [String] // fireBase UID
    var imageName = "peak-logo"
    var dateOfCreation: Date
    var accountID: String // The associated account ID
    var profileID: String
    
    var clientID: String?
    var clientName: String
    var phases: [Phase]
    
    
    //INFO ROW
    var durationInMonths: String
    var trainingFocus: String
    var intensity: String
    var progressionStrategy: String
    var totalTrainings: String
    
    var description: String
    
    // ... other properties and methods

}

struct Phase: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable {

    // IdentifiableItem properties
    var id = UUID().uuidString // fireBase UID
    var dataType: DataType { .phase }
    var title: String {
        return "\(phaseName)"
    }
    var subTitle: String{
        return "\(phaseDurationInWeeks) weeks"
    }
    var categoryIDs: [String]
    var imageName = "peak-logo"
    var dateOfCreation: Date
    var accountID: String // The associated account ID
    var profileID: String // The associated account ID
    var clientID: String? // Optional associated client ID
    var mezocycleID: String? // Optional associated client ID
    var phaseName: String
    var phaseDurationInWeeks: String
    var numberOfLoads: Int = 6



    // PHASE HEADER properties
    var headerClientName: String
    var headerPhaseInSeason: String
//    var haderInSeason: Bool
    var headerPeriodizationTitle: String
    var headerIntegrationGoal: String


    // SHEET PROPERTIES
    var sheetRows: [SheetRow]
    var trainingSessions: [TrainingSession] // these are computed aftewards
    // ... other properties and methods
    
}

struct Exercise: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable {
    var id = UUID().uuidString // fireBase UID
    var dataType: DataType { .exercise }
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var imageName = ""
    var dateOfCreation: Date
    var accountID: String // The associated account ID


    
    var bodyPart: String
    var recovery: Bool
    var baseMovement: String
    var difficulty: String
    

    var clientID: String? = nil


    var link: String
    var tags: Set<String>
}

struct TrainingSession: Identifiable, Hashable, Encodable, Decodable{
    var id = UUID().uuidString // fireBase UID
    var date: Date
    var volume: Double
    var percentIncrease: Double
    // ... other aggregated properties
}

struct SheetRow: Identifiable, Hashable, Encodable, Decodable, Equatable{
    var id = UUID().uuidString // fireBase UID
    var exerciseID: String
    var exerciseName: String
    var exerciseSettings: ExerciseSettings
    var allLoadsPerPhase = [Load(), Load(), Load(), Load(), Load(), Load()]
}

struct ExerciseSettings: Identifiable, Hashable, Encodable, Decodable{
    var id = UUID().uuidString // fireBase UID
    var tempo: String
    var rep: String
    var set: String
    var rest: String
    var micro: String
    
    static func getNew() -> ExerciseSettings {
        return ExerciseSettings(
            tempo: "",
            rep: "",
            set: "",
            rest: "",
            micro: ""
        )
    }
}

struct Load: Identifiable, Hashable, Encodable, Decodable{
    var id = UUID().uuidString // fireBase UID
    var loadString = ""
    var date: Date?
    var sets: [RepsWeights]?
    
}

struct RepsWeights: Codable, Hashable {
    var repetitions: Int?
    var weight: Int?
}



