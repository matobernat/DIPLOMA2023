//
//  MockDataModel.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 11/03/2023.
//

import SwiftUI





struct MockInfoRowData {
     let cardTitles = ["AGE", "CHART", "DEVELOPER", "LANGUAGE"]
     let cardValues = ["4+", "No.3", "SF Symbol", "EN"]
     let cardDescriptions = ["Years Old", "Finance", "Diligent Robot", "(English)"]
}

func getMockInfoRowItems() -> [InfoRowItem] {
    let mockData = MockInfoRowData()
    var infoRowItems = [InfoRowItem]()
    for index in 0..<mockData.cardTitles.count {
        let infoRowItem = InfoRowItem(
            title: mockData.cardTitles[index],
            value: mockData.cardValues[index],
            description: mockData.cardDescriptions[index]
        )
        infoRowItems.append(infoRowItem)
    }
    return infoRowItems
}


//protocol MockDetailView: View {
//    init(item: IdentifiableItem)
//}

protocol CardViewMock: View {
    init(item: IdentifiableItem)
}

//protocol IdentifiableItem {
//    var id: String { get set }
//    var dataType: DataType { get }
//    var title: String { get set }
//    var subTitle: String { get set }
//    var categoryIDs: [String] { get set }
//    var imageName: String { get set }
//
//    var clientID: String? { get set }
//
//}


// mezocycle aj phases musia byt v jednej kategorii training protocol
// odkial ich budem potom filtrovat a rozdelovat

struct CategoryMock: Identifiable, Hashable {
    var id: String
    var name: String
    var section: DataType
    var itemIDs: Set<String> // Use a Set for unique elements and faster lookups
    var isGlobal: Bool
    var iconName: String
}

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

enum SizeModelMock: String {
    case large = "Large"
    case medium = "Medium"
    case small = "Small"
}



struct ClientMock: IdentifiableItem, Identifiable, Hashable {
    var id: String
    var dataType: DataType { .client }
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var imageName = "client-photo"
    var dateOfCreation = Date.now
    var accountID = "MockAccount"


    
    var clientID: String? = nil

    
    var photoName: String
    var firstName: String
    var lastName: String
    var age: Int
    var weight: Int
    var height: Int
    
    var phaseIDs: [String]
    var mezocycleIDs: [String]
    var foodPlanIDs: [String]
    var measurementIDs: [String]
    var progressAlbumIDs: [String]
}

struct ExerciseMock: IdentifiableItem, Identifiable, Hashable {
    var id: String
    var dataType: DataType { .exercise }
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var imageName = ""
    var dateOfCreation = Date.now
    var accountID = "MockAccount"

    
    var clientID: String? = nil

    
    var link: String
    var tags: [String]
}

struct PhaseMock: IdentifiableItem {
    
    // IdentifiableItem properties
    var id: String
    var dataType: DataType { .phase }
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var imageName = "peak-logo"
    var clientID: String?
    var dateOfCreation = Date.now
    var accountID = "MockAccount"

    
    var exercisesIDs: [String]
    var sessionsIDs: [String]
}


struct MezocycleMock: IdentifiableItem {
    var id: String
    var dataType: DataType { .mezocycle }
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var imageName = "peak-logo"
    var dateOfCreation = Date.now
    var accountID = "MockAccount"

    
    var clientID: String?

    var phasesIDs: [String]
    // ... other properties and methods
}

struct FoodPlanMock: IdentifiableItem {
    var id: String
    var dataType: DataType { .foodPlan }
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var imageName = "foodplan-maintain-image"
    var dateOfCreation = Date.now
    var accountID = "MockAccount"

    
    var clientID: String?

}

struct MeasurementMock: IdentifiableItem {
    var id: String
    var dataType: DataType { .measurement }
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var imageName = "metric-image"
    var dateOfCreation = Date.now
    var accountID = "MockAccount"

    
    var clientID: String?

}

struct ProgressAlbumMock: IdentifiableItem {
    var id: String
    var dataType: DataType { .progressAlbum }
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var imageName = "photo-image"
    var dateOfCreation = Date.now
    var accountID = "MockAccount"

    
    var clientID: String?
    

}







struct PhaseMockNew: IdentifiableItem {

    // IdentifiableItem properties
    var id: String
    var dataType: DataType { .phase }
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var imageName = "peak-logo"
    var clientID: String?
    var dateOfCreation = Date.now
    var accountID = "MockAccount"



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

typealias RepsWeightTupleMock = (repetitions: Int, weight: Int)

struct LoadMock {
    var date: Date
    var sets: [RepsWeightTupleMock]
}






struct DataModelMock {
    static let categories: [CategoryMock] = [
        CategoryMock(id: "1", name: "All Clients", section: .client, itemIDs: Set(["100", "101","102", "103", "104", "105"]), isGlobal: true, iconName: "person.3.fill"),
        CategoryMock(id: "2", name: "Recent Clients", section: .client, itemIDs: Set(["103", "104", "105"]), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: "3", name: "My Clients", section: .client, itemIDs: Set(["100", "101", "104", "105"]), isGlobal: false, iconName: "person.2.fill"),
        CategoryMock(id: "4", name: "Favorite Clients", section: .client, itemIDs: Set(["100", "105"]), isGlobal: false, iconName: "star.fill"),
        
        CategoryMock(id: "5", name: "All Exercises", section: .exercise, itemIDs: Set(["200", "201", "202", "204", "205"]), isGlobal: true, iconName: "sportscourt.fill"),
        CategoryMock(id: "6", name: "Recent Exercises", section: .exercise, itemIDs: Set(["203", "204", "205"]), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: "7", name: "My Exercises", section: .exercise, itemIDs: Set(["200", "201", "204", "205"]), isGlobal: false, iconName: "sportscourt"),
        CategoryMock(id: "8", name: "Favorite Exercises", section: .exercise, itemIDs: Set(["200", "205"]), isGlobal: false, iconName: "star.fill"),
        
        CategoryMock(id: "9", name: "All Training Plans", section: .trainingPlan,
                     itemIDs: Set(["300", "301", "302", "303", "304", "305", "400", "401"]),
                     isGlobal: true, iconName: "list.bullet.rectangle"),
        CategoryMock(id: "10", name: "Recent Training Plans", section: .trainingPlan,
                     itemIDs: Set(["300", "301", "302", "303", "304", "305", "400", "401"]),
                     isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: "11", name: "My Training Plans", section: .trainingPlan,
                     itemIDs: Set(["300", "301", "302", "303", "304", "305", "400", "401"]),
                     isGlobal: false, iconName: "list.bullet.rectangle.portrait"),
        CategoryMock(id: "12", name: "Favorite Training Plans", section: .trainingPlan,
                     itemIDs: Set(["300", "301", "302", "303", "304", "305", "400"]),
                     isGlobal: false, iconName: "star.fill"),

        
        CategoryMock(id: "17", name: "All Food Plans", section: .foodPlan, itemIDs: Set(["500", "501", "502", "503", "504", "505"]), isGlobal: true, iconName: "leaf.fill"),
        CategoryMock(id: "18", name: "Recent Food Plans", section: .foodPlan, itemIDs: Set(["503", "504", "505"]), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: "19", name: "My Food Plans", section: .foodPlan, itemIDs: Set(["500", "501", "504", "505"]), isGlobal: false, iconName: "leaf"),
        CategoryMock(id: "20", name: "Favorite Food Plans", section: .foodPlan, itemIDs: Set(["500", "505"]), isGlobal: false, iconName: "star.fill"),

        CategoryMock(id: "21", name: "All Metrics", section: .measurement, itemIDs: Set(["600", "601", "602", "603", "604", "605"]), isGlobal: true, iconName: "chart.bar.fill"),
        CategoryMock(id: "22", name: "Recent Metrics", section: .measurement, itemIDs: Set(["603", "604", "605"]), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: "23", name: "My Metrics", section: .measurement, itemIDs: Set(["600", "601", "604", "605"]), isGlobal: false, iconName: "chart.bar"),
        CategoryMock(id: "24", name: "Favorite Metrics", section: .measurement, itemIDs: Set(["600", "605"]), isGlobal: false, iconName: "star.fill"),

        CategoryMock(id: "25", name: "All Progress Photos", section: .progressAlbum, itemIDs: Set(["700", "701", "702", "703", "704", "705"]), isGlobal: true, iconName: "camera.fill"),
        CategoryMock(id: "26", name: "Recent Progress Photos", section: .progressAlbum, itemIDs: Set(["703", "704", "705"]), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: "27", name: "My Progress Photos", section: .progressAlbum, itemIDs: Set(["700", "701", "704", "705"]), isGlobal: false, iconName: "camera"),
        CategoryMock(id: "28", name: "Favorite Progress Photos", section: .progressAlbum, itemIDs: Set(["700", "705"]), isGlobal: false, iconName: "star.fill")

    ]
    
    // Client Data
    static let clients: [ClientMock] = [
            
            ClientMock(id: "100", title: "Josh Smith", subTitle: "Active", categoryIDs: ["1", "3", "4"], photoName: "client-photo", firstName: "Josh", lastName: "Smith", age: 32, weight: 190, height: 72, phaseIDs: ["300", "301"], mezocycleIDs: ["400", "401"], foodPlanIDs: ["500", "504"], measurementIDs: ["600", "601"], progressAlbumIDs: ["700", "701"]),
            
            ClientMock(id: "101", title: "Emily Johnson", subTitle: "Active", categoryIDs: ["1", "3"], photoName: "client-photo", firstName: "Emily", lastName: "Johnson", age: 28, weight: 130, height: 65, phaseIDs: ["302"], mezocycleIDs: ["400", "401"], foodPlanIDs: ["503"], measurementIDs: ["602"], progressAlbumIDs: ["700", "701"]),
            
            ClientMock(id: "102", title: "Michael Brown", subTitle: "Active", categoryIDs: ["1", "3"], photoName: "client-photo", firstName: "Michael", lastName: "Brown", age: 45, weight: 210, height: 74, phaseIDs: ["303", "304"], mezocycleIDs: ["400", "401"], foodPlanIDs: ["502", "505"], measurementIDs: ["603", "604"], progressAlbumIDs: ["700", "701"]),
            
            ClientMock(id: "103", title: "Olivia Davis", subTitle: "Active", categoryIDs: ["1", "3", "4"], photoName: "client-photo",firstName: "Olivia", lastName: "Davis", age: 27, weight: 120, height: 64, phaseIDs: ["305"], mezocycleIDs: ["400", "401"], foodPlanIDs: ["501"], measurementIDs: ["605"], progressAlbumIDs: ["700", "701"]),
            
            ClientMock(id: "104", title: "Daniel Garcia", subTitle: "Active", categoryIDs: ["1", "3"], photoName: "client-photo",firstName: "Daniel", lastName: "Garcia", age: 35, weight: 180, height: 70, phaseIDs: ["301", "302"], mezocycleIDs: ["400", "401"], foodPlanIDs: ["504", "505"], measurementIDs: ["606", "607"], progressAlbumIDs: ["700", "701"]),
            
            ClientMock(id: "105", title: "Sophia Martinez", subTitle: "Active", categoryIDs: ["1", "3", "4"], photoName: "client-photo",firstName: "Sophia", lastName: "Martinez", age: 29, weight: 125, height: 66, phaseIDs: ["300", "303"], mezocycleIDs: ["400", "401"], foodPlanIDs: ["500", "503"], measurementIDs: ["608", "609"], progressAlbumIDs: ["700", "701"]),
            
            ClientMock(id: "106", title: "William Wilson", subTitle: "Active", categoryIDs: ["1", "3"], photoName: "client-photo", firstName: "William", lastName: "Wilson", age: 42, weight: 200, height: 73, phaseIDs: ["304", "305"], mezocycleIDs: ["400", "401"], foodPlanIDs: ["502", "504"], measurementIDs: ["610", "611"], progressAlbumIDs: ["700", "701"]),
            
            ClientMock(id: "107", title: "Ava Anderson", subTitle: "Active", categoryIDs: ["1", "3", "4"], photoName: "client-photo", firstName: "Ava", lastName: "Anderson", age: 25, weight: 115, height: 63, phaseIDs: ["306", "307"], mezocycleIDs: ["400", "401"], foodPlanIDs: ["505", "506"], measurementIDs: ["612", "613"], progressAlbumIDs: ["700", "701"])
        // ... more clients
            
    ]

    // Exercise Data
    static let exercises: [ExerciseMock] = [
        ExerciseMock(id: "200", title: "Bench Press", subTitle: "Chest", categoryIDs: ["5", "7", "8"], link: "https://www.example.com/bench_press", tags: ["chest", "compound", "barbell"]),
        ExerciseMock(id: "201", title: "Deadlift", subTitle: "Lower Back", categoryIDs: ["5", "7"], link: "https://www.example.com/deadlift", tags: ["lower_back", "compound", "barbell"]),
        ExerciseMock(id: "202", title: "Squat", subTitle: "Legs", categoryIDs: ["5", "7", "8"], link: "https://www.example.com/squat", tags: ["legs", "compound", "barbell"]),
        ExerciseMock(id: "203", title: "Pull-Up", subTitle: "Back", categoryIDs: ["5", "7"], link: "https://www.example.com/pull_up", tags: ["back", "compound", "bodyweight"]),
        ExerciseMock(id: "204", title: "Dumbbell Shoulder Press", subTitle: "Shoulders", categoryIDs: ["5", "7", "8"], link: "https://www.example.com/dumbbell_shoulder_press", tags: ["shoulders", "compound", "dumbbell"]),
        ExerciseMock(id: "205", title: "Bicep Curl", subTitle: "Biceps", categoryIDs: ["5", "7"], link: "https://www.example.com/bicep_curl", tags: ["biceps", "isolation", "dumbbell"])

        
        // ... more exercises
    ]

    // Training Protocol Data
    static let trainingProtocols: [PhaseMock] = [
        PhaseMock(id: "300", title: "Hypertrophy", subTitle: "PHASE 1", categoryIDs: ["9", "11", "12"], exercisesIDs: ["200", "201"], sessionsIDs: []),
        PhaseMock(id: "301",  title: "Strength", subTitle: "PHASE 1", categoryIDs: ["9", "11"], exercisesIDs: ["200", "201"], sessionsIDs: []),
        PhaseMock(id: "302", title: "Strength", subTitle: "PHASE 1", categoryIDs: ["9", "11", "12"], exercisesIDs: ["200", "201", "202"], sessionsIDs: ["3000", "3001", "3002"]),
        PhaseMock(id: "303", title: "Strength", subTitle: "PHASE 2", categoryIDs: ["9", "11"], exercisesIDs: ["203", "204", "205"], sessionsIDs: ["3003", "3004", "3005"]),
        PhaseMock(id: "304", title: "Mobility", subTitle: "PHASE 1", categoryIDs: ["9", "11", "12"], exercisesIDs: ["202", "203", "204"], sessionsIDs: ["3006", "3007", "3008"]),
        PhaseMock(id: "305", title: "Recovery", subTitle: "PHASE 1", categoryIDs: ["9", "11"], exercisesIDs: ["201", "202", "205"], sessionsIDs: ["3009", "3010", "3011"])
        // ... more training protocols
    ]

    // Mezocycle Data
    static let mezocycles: [MezocycleMock] = [
        MezocycleMock(id: "400", title: "Movie Star Plan", subTitle: "3 months", categoryIDs: ["9", "11", "12"], phasesIDs: ["300", "301"]),
        MezocycleMock(id: "401", title: "Spartan Plan", subTitle: "6 months", categoryIDs: ["9", "11"], phasesIDs: ["300", "301"]),

        // ... more mezocycles
    ]

    // Food Plan Data
    static let foodPlans: [FoodPlanMock] = [
        FoodPlanMock(id: "500", title: "Maintain", subTitle: "4 weeks", categoryIDs: ["17", "19", "20"]),
        FoodPlanMock(id: "501", title: "Hard Bulk", subTitle: "8 weeks", categoryIDs: ["17", "19"]),
        // ... more food plans
    ]

    // Measurement Data
    static let measurements: [MeasurementMock] = [
        MeasurementMock(id: "600", title: "Josh Smith", subTitle: "1. measurement", categoryIDs: ["21", "23", "24"]),
        MeasurementMock(id: "601", title: "Emily Johnson", subTitle: "1. measurement", categoryIDs: ["21", "23"]),
        MeasurementMock(id: "602", title: "Michael Brown", subTitle: "1. measurement", categoryIDs: ["21", "23", "24"]),
        // ... more measurements
    ]

    // ProgressPhoto Data
    static let progressPhotos: [ProgressAlbumMock] = [
        ProgressAlbumMock(id: "700", title: "Josh Smith", subTitle: "1. album", categoryIDs: ["25", "27", "28"]),
        ProgressAlbumMock(id: "701", title: "Emily Johnson", subTitle: "1. album", categoryIDs: ["25", "27"]),
        ProgressAlbumMock(id: "702", title: "Michael Brown", subTitle: "1. album", categoryIDs: ["25", "27", "28"]),
        // ... more progress photos
    ]

}






//struct DataModelMockOLD {
//    static let categories: [CategoryMock] = [
//        CategoryMock(id: 1, name: "All Clients", section: .client, itemIDs: Set((100...105)), isGlobal: true, iconName: "person.3.fill"),
//        CategoryMock(id: 2, name: "Recent Clients", section: .client, itemIDs: Set((103...105)), isGlobal: true, iconName: "clock.fill"),
//        CategoryMock(id: 3, name: "My Clients", section: .client, itemIDs: Set([100, 101, 104, 105]), isGlobal: false, iconName: "person.2.fill"),
//        CategoryMock(id: 4, name: "Favorite Clients", section: .client, itemIDs: Set([100, 105]), isGlobal: false, iconName: "star.fill"),
//
//        CategoryMock(id: 5, name: "All Exercises", section: .exercise, itemIDs: Set((200...205)), isGlobal: true, iconName: "sportscourt.fill"),
//        CategoryMock(id: 6, name: "Recent Exercises", section: .exercise, itemIDs: Set((203...205)), isGlobal: true, iconName: "clock.fill"),
//        CategoryMock(id: 7, name: "My Exercises", section: .exercise, itemIDs: Set([200, 201, 204, 205]), isGlobal: false, iconName: "sportscourt"),
//        CategoryMock(id: 8, name: "Favorite Exercises", section: .exercise, itemIDs: Set([200, 205]), isGlobal: false, iconName: "star.fill"),
//
//        CategoryMock(id: 9, name: "All Training Plans", section: .trainingPlan,
//                     itemIDs: Set([300, 301, 302, 303, 304, 305, 400, 401]),
//                     isGlobal: true, iconName: "list.bullet.rectangle"),
//        CategoryMock(id: 10, name: "Recent Training Plans", section: .trainingPlan,
//                     itemIDs: Set([300, 301, 302, 303, 304, 305, 400, 401]),
//                     isGlobal: true, iconName: "clock.fill"),
//        CategoryMock(id: 11, name: "My Training Plans", section: .trainingPlan,
//                     itemIDs: Set([300, 301, 302, 303, 304, 305, 400, 401]),
//                     isGlobal: false, iconName: "list.bullet.rectangle.portrait"),
//        CategoryMock(id: 12, name: "Favorite Training Plans", section: .trainingPlan,
//                     itemIDs: Set([300, 301, 302, 303, 304, 305, 400]),
//                     isGlobal: false, iconName: "star.fill"),
//
////        CategoryMock(id: 13, name: "All Mezocycles", section: .mezocycle, itemIDs: Set((400...405)), isGlobal: true, iconName: "list.bullet.rectangle"),
////        CategoryMock(id: 14, name: "Recent Mezocycles", section: .mezocycle, itemIDs: Set((403...405)), isGlobal: true, iconName: "clock.fill"),
////        CategoryMock(id: 15, name: "My Mezocycles", section: .mezocycle, itemIDs: Set([400, 401, 404, 405]), isGlobal: false, iconName: "list.bullet.rectangle.portrait"),
////        CategoryMock(id: 16, name: "Favorite Mezocycles", section: .mezocycle, itemIDs: Set([400, 405]), isGlobal: false, iconName: "star.fill"),
//
//        CategoryMock(id: 17, name: "All Food Plans", section: .foodPlan, itemIDs: Set((500...505)), isGlobal: true, iconName: "leaf.fill"),
//        CategoryMock(id: 18, name: "Recent Food Plans", section: .foodPlan, itemIDs: Set((503...505)), isGlobal: true, iconName: "clock.fill"),
//        CategoryMock(id: 19, name: "My Food Plans", section: .foodPlan, itemIDs: Set([500, 501, 504, 505]), isGlobal: false, iconName: "leaf"),
//        CategoryMock(id: 20, name: "Favorite Food Plans", section: .foodPlan, itemIDs: Set([500, 505]), isGlobal: false, iconName: "star.fill"),
//
//        CategoryMock(id: 21, name: "All Metrics", section: .measurement, itemIDs: Set((600...605)), isGlobal: true, iconName: "chart.bar.fill"),
//        CategoryMock(id: 22, name: "Recent Metrics", section: .measurement, itemIDs: Set((603...605)), isGlobal: true, iconName: "clock.fill"),
//        CategoryMock(id: 23, name: "My Metrics", section: .measurement, itemIDs: Set([600, 601, 604, 605]), isGlobal: false, iconName: "chart.bar"),
//        CategoryMock(id: 24, name: "Favorite Metrics", section: .measurement, itemIDs: Set([600, 605]), isGlobal: false, iconName: "star.fill"),
//
//        CategoryMock(id: 25, name: "All Progress Photos", section: .progressAlbum, itemIDs: Set((700...705)), isGlobal: true, iconName: "camera.fill"),
//        CategoryMock(id: 26, name: "Recent Progress Photos", section: .progressAlbum, itemIDs: Set((703...705)), isGlobal: true, iconName: "clock.fill"),
//        CategoryMock(id: 27, name: "My Progress Photos", section: .progressAlbum, itemIDs: Set([700, 701, 704, 705]), isGlobal: false, iconName: "camera"),
//        CategoryMock(id: 28, name: "Favorite Progress Photos", section: .progressAlbum, itemIDs: Set([700, 705]), isGlobal: false, iconName: "star.fill"),
//    ]
//
//    // Client Data
//    static let clients: [ClientMock] = [
//        ClientMock(id: 100, title: "Josh Smith", subTitle: "Active", categoryIDs: [1, 3, 4], photoName: "client-photo", firstName: "Josh", lastName: "Smith", age: 32, weight: 190, height: 72, phaseIDs: [300, 301], mezocycleIDs: [400,401], foodPlanIDs: [500, 504], measurementIDs: [600, 601], progressAlbumIDs: [700, 701]),
//        ClientMock(id: 101, title: "Emily Johnson", subTitle: "Active", categoryIDs: [1, 3], photoName: "client-photo", firstName: "Emily", lastName: "Johnson", age: 28, weight: 130, height: 65, phaseIDs: [302], mezocycleIDs: [400,401], foodPlanIDs: [503], measurementIDs: [602], progressAlbumIDs: [700, 701]),
//        ClientMock(id: 102, title: "Michael Brown", subTitle: "Active", categoryIDs: [1, 3], photoName: "client-photo", firstName: "Michael", lastName: "Brown", age: 45, weight: 210, height: 74, phaseIDs: [303, 304], mezocycleIDs: [400,401], foodPlanIDs: [502, 505], measurementIDs: [603, 604], progressAlbumIDs: [700, 701]),
//        ClientMock(id: 103, title: "Olivia Davis", subTitle: "Active", categoryIDs: [1, 3, 4], photoName: "client-photo",firstName: "Olivia", lastName: "Davis", age: 27, weight: 120, height: 64, phaseIDs: [305], mezocycleIDs: [400,401], foodPlanIDs: [501], measurementIDs: [605], progressAlbumIDs: [700, 701]),
//        ClientMock(id: 104, title: "Daniel Garcia", subTitle: "Active", categoryIDs: [1, 3], photoName: "client-photo",firstName: "Daniel", lastName: "Garcia", age: 35, weight: 180, height: 70, phaseIDs: [301, 302], mezocycleIDs: [400,401], foodPlanIDs: [504, 505], measurementIDs: [606, 607], progressAlbumIDs: [700, 701]),
//        ClientMock(id: 105, title: "Sophia Martinez", subTitle: "Active", categoryIDs: [1, 3, 4], photoName: "client-photo",firstName: "Sophia", lastName: "Martinez", age: 29, weight: 125, height: 66, phaseIDs: [300, 303], mezocycleIDs: [400,401], foodPlanIDs: [500, 503], measurementIDs: [608, 609], progressAlbumIDs: [700, 701]),
//        ClientMock(id: 106, title: "William Wilson", subTitle: "Active", categoryIDs: [1, 3], photoName: "client-photo",firstName: "William", lastName: "Wilson", age: 42, weight: 200, height: 73, phaseIDs: [304, 305], mezocycleIDs: [400,401], foodPlanIDs: [502, 504], measurementIDs: [610, 611], progressAlbumIDs: [700, 701]),
//        ClientMock(id: 107, title: "Ava Anderson", subTitle: "Active", categoryIDs: [1, 3, 4], photoName: "client-photo",firstName: "Ava", lastName: "Anderson", age: 25, weight: 115, height: 63, phaseIDs: [306, 307], mezocycleIDs: [400,401], foodPlanIDs: [505, 506], measurementIDs: [612, 613], progressAlbumIDs: [700, 701])
//
//        // ... more clients
//    ]
//
//    // Exercise Data
//    static let exercises: [ExerciseMock] = [
//        ExerciseMock(id: 200, title: "Bench Press", subTitle: "Chest", categoryIDs: [5, 7, 8], link: "https://www.example.com/bench_press", tags: ["chest", "compound", "barbell"]),
//        ExerciseMock(id: 201, title: "Deadlift", subTitle: "Lower Back", categoryIDs: [5, 7], link: "https://www.example.com/deadlift", tags: ["lower_back", "compound", "barbell"]),
//        ExerciseMock(id: 202, title: "Squat", subTitle: "Legs", categoryIDs: [5, 7, 8], link: "https://www.example.com/squat", tags: ["legs", "compound", "barbell"]),
//        ExerciseMock(id: 203, title: "Pull-Up", subTitle: "Back", categoryIDs: [5, 7], link: "https://www.example.com/pull_up", tags: ["back", "compound", "bodyweight"]),
//        ExerciseMock(id: 204, title: "Dumbbell Shoulder Press", subTitle: "Shoulders", categoryIDs: [5, 7, 8], link: "https://www.example.com/dumbbell_shoulder_press", tags: ["shoulders", "compound", "dumbbell"]),
//        ExerciseMock(id: 205, title: "Bicep Curl", subTitle: "Biceps", categoryIDs: [5, 7], link: "https://www.example.com/bicep_curl", tags: ["biceps", "isolation", "dumbbell"]),
//
//        // ... more exercises
//    ]
//
//    // Training Protocol Data
//    static let trainingProtocols: [PhaseMock] = [
//        PhaseMock(id: 300, title: "Hypertrophy", subTitle: "PHASE 1", categoryIDs: [9, 11, 12], exercisesIDs: [200, 201], sessionsIDs: []),
//        PhaseMock(id: 301,  title: "Strength", subTitle: "PHASE 1", categoryIDs: [9, 11], exercisesIDs: [200, 201], sessionsIDs: []),
//        PhaseMock(id: 302, title: "Strength", subTitle: "PHASE 1", categoryIDs: [9, 11, 12], exercisesIDs: [200, 201, 202], sessionsIDs: [3000, 3001, 3002]),
//        PhaseMock(id: 303, title: "Strength", subTitle: "PHASE 2", categoryIDs: [9, 11], exercisesIDs: [203, 204, 205], sessionsIDs: [3003, 3004, 3005]),
//        PhaseMock(id: 304, title: "Mobility", subTitle: "PHASE 1", categoryIDs: [9, 11, 12], exercisesIDs: [202, 203, 204], sessionsIDs: [3006, 3007, 3008]),
//        PhaseMock(id: 305, title: "Recovery", subTitle: "PHASE 1", categoryIDs: [9, 11], exercisesIDs: [201, 202, 205], sessionsIDs: [3009, 3010, 3011]),
//
//        // ... more training protocols
//    ]
//
//    // Mezocycle Data
//    static let mezocycles: [MezocycleMock] = [
//        MezocycleMock(id: 400, title: "Movie Star Plan", subTitle: "3 months", categoryIDs: [9, 11, 12], phasesIDs: [300, 301]),
//        MezocycleMock(id: 401, title: "Spartan Plan", subTitle: "6 months", categoryIDs: [9, 11], phasesIDs: [300, 301]),
//        // ... more mezocycles
//    ]
//
//    // Food Plan Data
//    static let foodPlans: [FoodPlanMock] = [
//        FoodPlanMock(id: 500, title: "Maintain", subTitle: "4 weeks", categoryIDs: [17, 19, 20]),
//        FoodPlanMock(id: 501, title: "Hard Bulk", subTitle: "8 weeks", categoryIDs: [17, 19]),
//        // ... more food plans
//    ]
//
//    // Measurement Data
//    static let measurements: [MeasurementMock] = [
//        MeasurementMock(id: 600, title: "Josh Smith", subTitle: "1. measurement", categoryIDs: [21, 23, 24]),
//        MeasurementMock(id: 601, title: "Emily Johnson", subTitle: "1. measurement", categoryIDs: [21, 23]),
//        MeasurementMock(id: 602, title: "Michael Brown", subTitle: "1. measurement", categoryIDs: [21, 23, 24]),
//        // ... more measurements
//    ]
//
//    // ProgressPhoto Data
//    static let progressPhotos: [ProgressAlbumMock] = [
//        ProgressAlbumMock(id: 700, title: "Josh Smith", subTitle: "1. album", categoryIDs: [25, 27, 28]),
//        ProgressAlbumMock(id: 701, title: "Emily Johnson", subTitle: "1. album", categoryIDs: [25, 27]),
//        ProgressAlbumMock(id: 702, title: "Michael Brown", subTitle: "1. album", categoryIDs: [25, 27, 28]),
//        // ... more progress photos
//    ]
//
//}
