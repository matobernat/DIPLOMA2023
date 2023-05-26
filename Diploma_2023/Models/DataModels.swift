//
//  DataModels.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 04/04/2023.
//

import SwiftUI


// MARK: - Supportive Structure functions



// MARK: - Supportive Structures

struct InfoRowItem: Identifiable{
    var id = UUID()
    var title: String
    var value: String
    var description: String
    
}




// MARK: - Main Data Models

struct Account: Identifiable, Hashable, Codable, Equatable {
    
    var id: String // fireBase UID
    var name: String?
    var email: String
    var address: String
    var loggedProfile: Profile?
    var profiles: [Profile]
    var dateOfCreation: Date

    // ... other properties
}


struct Profile: Codable, Equatable, Hashable {
    var id: String // fireBase UID
    var name: String
    var email: String?
    var dateOfCreation: Date

    // ... other properties
}


enum SizeModel: String {
    case large = "Large"
    case medium = "Medium"
    case small = "Small"
}


protocol DetailView: View {
    init(item: IdentifiableItem)
}

protocol CardView: View {
    init(item: IdentifiableItem)
}

protocol IdentifiableItem {
    var id: String { get }
    var dataType: DataType { get }
    var title: String { get }
    var subTitle: String { get }
    var categoryIDs: [String] { get }
    var imageName: String { get }
    var dateOfCreation: Date { get }
    var accountID: String { get }

    var clientID: String? { get }

}


enum DataType: String, Codable, CaseIterable {
    case client = "client"
    case exercise = "exercise"
    case trainingPlan = "trainingPlan" // this is section type (for category), not data type
    case mezocycle = "mezocycle"
    case phase = "phase"
    case foodPlan = "foodPlan"
    case measurement = "measurement"
    case progressAlbum = "progressAlbum"
}

enum VersionEnum: String, CaseIterable, Codable {
    case version1_0 = "1.0"
    case version1_1 = "1.1"
    case version1_2 = "1.2"
    case version1_3 = "1.3"
    case version2_0 = "2.0"
    case version2_1 = "2.1"
    case version2_2 = "2.2"
    case version2_3 = "2.3"
    case version3_0 = "3.0"
    case version3_1 = "3.1"
    case version3_2 = "3.2"
    case version3_3 = "3.3"
}


extension PaymentType: Identifiable {
  var id: Self { self }
}
enum PaymentType: String, Codable, CaseIterable, Equatable {
    case perSession = "Per session"
    case monthly = "Monthly"
    case oneTime = "One time purchase"
    case weekly = "Weekly"
}


extension TrainingStyle: Identifiable {
  var id: Self { self }
}
enum TrainingStyle: String, Codable, CaseIterable, Equatable  {
    case distant = "Distant"
    case inPerson = "In person"

}


//struct Category: Identifiable, Hashable, Encodable, Decodable  {
//    var id: String // fireBase UID
//    var name: String
//    var section: DataType // enum, clients, tranining plans, exercises
//    var itemIDs: Set<String> // Use a Set for unique elements and faster lookups
//    var isGlobal: Bool // The type of the category (global or profile)
//    var iconName: String
//    var accountID: String // The associated account ID
//    var profileID: String? // The associated profile ID, if applicable
//}


struct Category: Identifiable, Hashable, Encodable, Decodable  {
    var id: String // fireBase UID
    var name: String
    var dataType: DataType // enum, clients, tranining plans, exercises
    var isGlobal: Bool // The type of the category (account level or profile level)
    var accountID: String // The associated account ID
    var dateOfCreation: Date
    var profileID: String? // The associated profile ID, if applicable
    var imageName: String
}


//struct Client: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable  {
//
//    //<IdentifiableItem properties>
//    var id = UUID().uuidString // fireBase UID
//    var dataType: DataType { .client }
//    var title: String {
//        return "\(firstName) \(lastName)"
//    }
//    var subTitle: String{
//        return active ? "Active" : "Inactive"
//    }
//    var categoryIDs: [String]
//    var imageName = "client-photo"
//    var dateOfCreation: Date
//
//
//    var clientID: String? = nil
//    var accountID: String
//    var profileID: String
//
//
//    // personal info
//    var firstName: String
//    var lastName: String
//
//    var email: String
//    var phone: String
//
//    var age: String
//    var weight: String
//    var height: String
//    var active: Bool
//    var allSessionsCount: Int = 0
//    var doneSessionsCount: Int = 0
//
//
//    // Info list row
//    var trainingStyle: TrainingStyle
//    var injury: String
//    var healthIssues: String
//    var paymentType: PaymentType
//
//
//    var phases = [Phase]()
//    var mezocycles =  [Mezocycle]()
//    var foodPlanIDs: [String]
//    var measurementIDs: [String]
//    var progressAlbumIDs: [String]
//}


//struct Exercise: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable {
//    var id = UUID().uuidString // fireBase UID
//    var dataType: DataType { .exercise }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [String]
//    var imageName = ""
//    var dateOfCreation: Date
//    var accountID: String // The associated account ID
//
//
//
//    var bodyPart: String
//    var recovery: Bool
//    var baseMovement: String
//    var difficulty: String
//
//
//    var clientID: String? = nil
//
//
//    var link: String
//    var tags: Set<String>
//}

//struct Phase: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable {
//
//    // IdentifiableItem properties
//    var id = UUID().uuidString // fireBase UID
//    var dataType: DataType { .phase }
//    var title: String {
//        return "\(phaseName)"
//    }
//    var subTitle: String{
//        return "\(phaseDurationInWeeks) weeks"
//    }
//    var categoryIDs: [String]
//    var imageName = "peak-logo"
//    var dateOfCreation: Date
//    var accountID: String // The associated account ID
//    var profileID: String // The associated account ID
//    var clientID: String? // Optional associated client ID
//    var phaseName: String
//    var phaseDurationInWeeks: String
//
//
//
//    // PHASE HEADER properties
//    var headerClientName: String
//    var headerPhaseInSeason: String
////    var haderInSeason: Bool
//    var headerPeriodizationTitle: String
//    var headerIntegrationGoal: String
//
//
//    // SHEET PROPERTIES
//    var sheetRows: [SheetRow]
//    var trainingSessions: [TrainingSession] // these are computed aftewards
//    // ... other properties and methods
//
//}
//
//struct TrainingSession: Identifiable, Hashable, Encodable, Decodable{
//    var id = UUID().uuidString // fireBase UID
//    var date: Date
//    var volume: Double
//    var percentIncrease: Double
//    // ... other aggregated properties
//}
//
//
//struct SheetRow: Identifiable, Hashable, Encodable, Decodable, Equatable{
//    var id = UUID().uuidString // fireBase UID
//    var exerciseID: String
//    var exerciseName: String
//    var exerciseSettings: ExerciseSettings
//    var allLoadsPerPhase = [Load(), Load(), Load(), Load()]
//}
//
//struct ExerciseSettings: Identifiable, Hashable, Encodable, Decodable{
//    var id = UUID().uuidString // fireBase UID
//    var tempo: String
//    var rep: String
//    var set: String
//    var rest: String
//    var micro: String
//}
//
//struct Load: Identifiable, Hashable, Encodable, Decodable{
//    var id = UUID().uuidString // fireBase UID
//    var loadString = ""
//    var date: Date?
//    var sets: [RepsWeights]?
//
//}
//
////typealias RepsWeightTuple = (repetitions: Int, weight: Int)
//
//struct RepsWeights: Codable, Hashable {
//    var repetitions: Int?
//    var weight: Int?
//}
//
//
//
//struct Mezocycle: IdentifiableItem,Identifiable, Hashable, Encodable, Decodable {
//    var id = UUID().uuidString // fireBase UID
//    var dataType: DataType { .mezocycle }
//    var title: String
//    var subTitle: String{
//        return "\(durationInMonths) months"
//    }
//    var categoryIDs: [String] // fireBase UID
//    var imageName = "peak-logo"
//    var dateOfCreation: Date
//    var accountID: String // The associated account ID
//    var profileID: String
//
//    var clientID: String?
//    var phases: [Phase]
//
//
//    //INFO ROW
//    var durationInMonths: String
//    var trainingFocus: String
//    var intensity: String
//    var progressionStrategy: String
//    var totalTrainings: String
//
//    var description: String
//
//    // ... other properties and methods
//
//}
//
//












//
//struct FoodPlan: IdentifiableItem {
//    var id = UUID()
//    var dataType: DataType { .foodPlan }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [UUID]
//    var imageName = "foodplan-maintain-image"
//
//    var clientID: UUID?
//
//}
//
//struct Measurement: IdentifiableItem {
//    var id = UUID()
//    var dataType: DataType { .measurement }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [UUID]
//    var imageName = "metric-image"
//
//    var clientID: UUID?
//
//}
//
//struct ProgressAlbum: IdentifiableItem {
//    var id = UUID()
//    var dataType: DataType { .progressAlbum }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [UUID]
//    var imageName = "photo-image"
//
//    var clientID: UUID?
//
//
//}
