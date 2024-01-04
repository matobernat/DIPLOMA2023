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
    var placeholderName = "peak-logo"
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
    var placeholderName = "peak-logo"
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
    var placeholderName = ""
    var dateOfCreation: Date
    var accountID: String // The associated account ID
    var profileID: String?


    
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
    var loadPlaceholders: [String] = []
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
    
    static func getPredefined() -> ExerciseSettings {
        return ExerciseSettings(
            tempo: "2,2,2,2",
            rep: "6-8",
            set: "4",
            rest: "180'",
            micro: "W1"
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







// MARK: Latest Exercise Data, LED logic functions



// Main function of the LED logic
extension Phase {
    
    // this function will synt the Phase to LED
    func syncLED(client: Client) -> Phase {
        var myPhase = self
        let allLEDs = LED.getLEDdict(phases: client.getAllPhases())

        myPhase.sheetRows = myPhase.sheetRows.map { sheetRow in
            if let led = allLEDs[sheetRow.exerciseID] {
                return sheetRow.copyLED(led: led)
            }
            return sheetRow
        }

        return myPhase
    }
    
}



extension LED {
    
    // produces LED object
    static func set(sheetRow: SheetRow, dateOfCreation: Date) -> LED {
        // Check if any load has a non-empty loadString
        let hasLoads = sheetRow.allLoadsPerPhase.contains { !$0.loadString.isEmpty }

        // Assuming placeholders is a property that can be set similar to loads
        // Check if any placeholder is non-empty
        let hasPlaceholders = sheetRow.loadPlaceholders.contains { $0 != "" }

        return LED(
            exerciseID: sheetRow.exerciseID,
            dateOfCreation: dateOfCreation,
            sheetRow: sheetRow,
            hasLoads: hasLoads,
            hasPlaceholders: hasPlaceholders
        )
    }
    
    // returns prefered LED
    static func betterLED(led1: LED, led2: LED) -> Bool {
        // Priority 1: Check for loads
        if led1.hasLoads && !led2.hasLoads {
            return true
        } else if !led1.hasLoads && led2.hasLoads {
            return false
        }

        // Priority 2: Check for placeholders
        if led1.hasPlaceholders && !led2.hasPlaceholders {
            return true
        } else if !led1.hasPlaceholders && led2.hasPlaceholders {
            return false
        }

        // Priority 3: Check for newer date of creation
        return led1.dateOfCreation > led2.dateOfCreation
    }
    
    
    // creates a Dictionary of LEDS from phases
    static func getLEDdict(phases: [Phase]) -> [String: LED] {
        var leds = [String: LED]()

        for phase in phases {
            for sheetRow in phase.sheetRows {
                let newLED = LED.set(sheetRow: sheetRow, dateOfCreation: phase.dateOfCreation)

                if let existingLED = leds[newLED.exerciseID] {
                    if betterLED(led1: newLED, led2: existingLED) {
                        leds[newLED.exerciseID] = newLED
                    }
                } else {
                    leds[newLED.exerciseID] = newLED
                }
            }
        }

        return leds
    }
    
    
    
    
}





extension SheetRow {
    func copyLED(led: LED) -> SheetRow {
        var sheetRow = self // Assuming self.copy creates a deep copy of the SheetRow

        if led.hasLoads {
            sheetRow.allLoadsPerPhase = led.sheetRow.allLoadsPerPhase.filter { !$0.loadString.isEmpty }
            sheetRow.exerciseSettings = led.sheetRow.exerciseSettings
        } else if led.hasPlaceholders {
            // Assuming placeholders is a property that can be set
            sheetRow.allLoadsPerPhase = led.sheetRow.allLoadsPerPhase.filter { !$0.loadString.isEmpty }
            sheetRow.exerciseSettings = led.sheetRow.exerciseSettings
        } else {
            sheetRow.exerciseSettings = led.sheetRow.exerciseSettings
        }

        return sheetRow
    }
}




// Basically a sheetrow with added flags for easier manipulation of the data
struct LED: Hashable{
    var exerciseID: String
    var dateOfCreation: Date
    var sheetRow: SheetRow
    var hasLoads: Bool
    var hasPlaceholders: Bool

//    static func == (lhs: LED, rhs: LED) -> Bool {
//        return lhs.exerciseID == rhs.exerciseID
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(exerciseID)
//    }
//    
    
    
}












