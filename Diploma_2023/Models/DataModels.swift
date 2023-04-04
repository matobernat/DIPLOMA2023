//
//  DataModels.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 04/04/2023.
//

import SwiftUI


struct Account: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var address: String
    var globalCategories: [UUID] // Global categories
    var trainerProfiles: [UUID] // Trainer profiles associated with the account

    // ... other properties
}


struct Profile: Identifiable {
    var id = UUID()
     var name: String
     var accountID: UUID
    var password: String
    var email: String
    // ... other properties
}





//protocol DetailView: View {
//    init(item: IdentifiableItem)
//}
//
//protocol CardView: View {
//    init(item: IdentifiableItem)
//}

//protocol IdentifiableItem {
//    var id: Int { get set }
//    var dataType: DataType { get }
//    var title: String { get set }
//    var subTitle: String { get set }
//    var categoryIDs: [Int] { get set }
//    var imageName: String { get set }
//
//    var clientID: Int? { get set }
//
//}
//
//enum DataType: String {
//    case client = "client"
//    case exercise = "exercise"
//    case trainingPlan = "trainingPlan"
//    case mezocycle = "mezocycle"
//    case phase = "phase"
//    case foodPlan = "foodPlan"
//    case measurement = "measurement"
//    case progressAlbum = "progressAlbum"
//}
//
//enum SizeModel: String {
//    case large = "Large"
//    case medium = "Medium"
//    case small = "Small"
//}
//
//
//struct Category: Identifiable, Hashable {
//    var id: Int
//    var name: String
//    var section: DataType
//    var itemIDs: Set<Int> // Use a Set for unique elements and faster lookups
//    var isGlobal: Bool
//    var iconName: String
//}
//
//
//struct Client: IdentifiableItem, Identifiable, Hashable {
//    var id = UUID()
//    var dataType: DataType { .client }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [UUID]
//    var imageName = "client-photo"
//
//    var clientID: UUID? = nil
//    var accountID: UUID
//
//
//    var photoName: String
//    var firstName: String
//    var lastName: String
//    var age: Int
//    var weight: Int
//    var height: Int
//
//    var phaseIDs: [Int]
//    var mezocycleIDs: [Int]
//    var foodPlanIDs: [Int]
//    var measurementIDs: [Int]
//    var progressAlbumIDs: [Int]
//}
//
//
//struct Exercise: IdentifiableItem, Identifiable, Hashable {
//    var id: Int
//    var dataType: DataType { .exercise }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [Int]
//    var imageName = ""
//
//    var clientID: Int? = nil
//
//
//    var link: String
//    var tags: [String]
//}
//
//struct Phase: IdentifiableItem {
//
//    // IdentifiableItem properties
//    var id: Int
//    var dataType: DataType { .phase }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [Int]
//    var imageName = "peak-logo"
//    var clientID: Int?
//
//
//    // PHASE HEADER properties
//    var clientName: String
//    var phase: String
//    var periodization: String
//    var integrationGoal: String
//
//
//    // SHEET PROPERTIES
//    var sheetRowIDs: [Int]
//    var trainingSessions: [TrainingSessionMock]
//    // ... other properties and methods
//}
//
//struct SheetRow: Identifiable{
//    var id: Int
//    var exerciseID: Int
//    var exerciseName: String
//    var clientID: Int
//    var exerciseSettings: [ExerciseSettingsMock]
//    var loads: [[LoadMock]] // 2D array where each row represents a phase, and each column represents a training session
//    var loadsStrings:[String]
//
//    var phaseIndices: [Int: Int] // Maps phase IDs to their corresponding index in the loads 2D array
//}
//
//struct ExerciseSettings {
//    var phaseID: Int
//    var tempo: String
//    var rep: String
//    var set: String
//    var rest: String
//    var micro: String
//}
//
//struct TrainingSessionk {
//    var sessionIndex: Int
//    var date: Date
//    var volume: Double
//    var percentIncrease: Double
//    // ... other aggregated properties
//}
//
//typealias RepsWeightTuple = (repetitions: Int, weight: Int)
//
//struct LoadMock {
//    var date: Date
//    var sets: [RepsWeightTuple]
//}
//
//struct Mezocycle: IdentifiableItem {
//    var id: Int
//    var dataType: DataType { .mezocycle }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [Int]
//    var imageName = "peak-logo"
//
//    var clientID: Int?
//
//    var phasesIDs: [Int]
//    // ... other properties and methods
//}
//
//struct FoodPlan: IdentifiableItem {
//    var id: Int
//    var dataType: DataType { .foodPlan }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [Int]
//    var imageName = "foodplan-maintain-image"
//
//    var clientID: Int?
//
//}
//
//struct Measurement: IdentifiableItem {
//    var id: Int
//    var dataType: DataType { .measurement }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [Int]
//    var imageName = "metric-image"
//
//    var clientID: Int?
//
//}
//
//struct ProgressAlbum: IdentifiableItem {
//    var id: Int
//    var dataType: DataType { .progressAlbum }
//    var title: String
//    var subTitle: String
//    var categoryIDs: [Int]
//    var imageName = "photo-image"
//
//    var clientID: Int?
//
//
//}
