//
//  MockDataModel.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 11/03/2023.
//

import SwiftUI




//
//struct MockAccount{
//    let account = Account(id: UUID(), name: "Test Account", password: "password", email: "test@example.com")
//}
//
//struct MockCoaches{
//    let coach1 = Coach(id: UUID(), name: "Coach 1", email: "coach1@example.com", accountId: MockAccount().account.id)
//    let coach2 = Coach(id: UUID(), name: "Coach 2", email: "coach2@example.com", accountId: MockAccount().account.id)
//}
//
//struct MockClients{
//    let client1 = Client(firstName: "John", lastName: "Doe", email: "john@example.com", phone: "555-1234", accountId: MockAccount().account.id)
//    let client2 = Client(firstName: "Jane", lastName: "Doe", email: "jane@example.com", phone: "555-5678", accountId: MockAccount().account.id)
//    let client3 = Client(firstName: "Bob", lastName: "Smith", email: "bob@example.com", phone: "555-9012", accountId: MockAccount().account.id)
//    let client4 = Client(firstName: "Alice", lastName: "Smith", email: "alice@example.com", phone: "555-3456", accountId: MockAccount().account.id)
//    let client5 = Client(firstName: "Mike", lastName: "Johnson", email: "mike@example.com", phone: "555-7890", accountId: MockAccount().account.id)
//    let client6 = Client(firstName: "Sara", lastName: "Johnson", email: "sara@example.com", phone: "555-2345", accountId: MockAccount().account.id)
//    let client7 = Client(firstName: "Tom", lastName: "Williams", email: "tom@example.com", phone: "555-6789", accountId: MockAccount().account.id)
//    let client8 = Client(firstName: "Amy", lastName: "Williams", email: "amy@example.com", phone: "555-0123", accountId: MockAccount().account.id)
//}
//
//struct MockCategories{
//
//    // GLOBAL
//    static let allClientsCategory = Category(id: UUID(),
//                                  name: "All Clients",
//                                  isGlobalCategory: true,
//                                  clientIds: [],
//                                  coachId: nil,
//                                  accountId: MockAccount().account.id)
//
//    static let category1 = Category(id: UUID(),
//                             name: "Hockey Players",
//                             isGlobalCategory: true,
//                             clientIds: [MockClients().client3.id,
//                                         MockClients().client4.id,
//                                         MockClients().client7.id,
//                                         MockClients().client8.id],
//                             coachId: nil,
//                             accountId: MockAccount().account.id)
//
//    // LOCAL
//    static let category2 = Category(id: UUID(),
//                             name: "My clients",
//                             isGlobalCategory: false,
//                             clientIds: [MockClients().client1.id, MockClients().client2.id],
//                             coachId: MockCoaches().coach1.id,
//                             accountId: MockAccount().account.id)
//
//    static let category3 = Category(id: UUID(),
//                             name: "My clients",
//                             isGlobalCategory: false,
//                             clientIds: [MockClients().client5.id, MockClients().client6.id],
//                             coachId: MockCoaches().coach2.id,
//                             accountId: MockAccount().account.id)
//
//    static let categories = [allClientsCategory, category1, category2, category3 ]
//
//}
//






struct MockCategory: Decodable, Identifiable{
    let id: Int
    let name: String
    let isGlobalCategory: Bool
    let clients: [MockClient]
}

struct MockClient: Decodable, Identifiable{
    let id: Int
    let name: String
}


class MockClientModel {
    let categories: [MockCategory]

    init(){
        let client1 = MockClient(id: 1, name: "John")
        let client2 = MockClient(id: 2, name: "Mary")
        let client3 = MockClient(id: 3, name: "Bob")
        let client4 = MockClient(id: 4, name: "Alice")
        let client5 = MockClient(id: 5, name: "Tom")
        let client6 = MockClient(id: 6, name: "Jane")
        let client7 = MockClient(id: 7, name: "Mike")
        let client8 = MockClient(id: 8, name: "Lisa")

        let allClientsCategory = MockCategory(id: 1, name: "All Clients", isGlobalCategory: true, clients: [client1, client2, client3, client4, client5, client6, client7, client8])
        let globalHockeyCategory = MockCategory(id: 2, name: "Global Hockey", isGlobalCategory: true, clients: [client1, client2, client3, client4])
        let localMyClients = MockCategory(id: 3, name: "Local My Clients", isGlobalCategory: false, clients: [client3, client4, client5, client6])
        let localHockeyCategory = MockCategory(id: 4, name: "Local Hockey", isGlobalCategory: false, clients: [client3, client4])

        self.categories = [allClientsCategory, globalHockeyCategory, localMyClients, localHockeyCategory]
    }

    func category(id: Int?) -> MockCategory? {
        if let id = id {
            return categories.first(where: { $0.id == id })
        } else {
            return nil
        }
    }
}

let mockClientModel = MockClientModel()









struct Item: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let description: String = "Description"
}


struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let itemIds: [Int]
    let isGlobalCategory: Bool
}


struct MockCategoryItemData {
    static let categories = [
        Category(name: "All Trainees", itemIds: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], isGlobalCategory: true),
        Category(name: "Favorite Trainees", itemIds: [1, 2, 3, 4, 5, 6,], isGlobalCategory: true),
        Category(name: "My Trainees", itemIds: [5, 6, 7, 8, 9, 10], isGlobalCategory: false),
        Category(name: "My Hockey Players", itemIds: [5, 6, 7], isGlobalCategory: false),
    ]
    
//    static let categories = [
//        Category(name: "All Trainees", itemIds: [1, 2, 3], isGlobalCategory: true),
//        Category(name: "Favorite Trainees", itemIds: [4, 5], isGlobalCategory: true),
//        Category(name: "My Trainees", itemIds: [ 6, 7, 8], isGlobalCategory: false),
//        Category(name: "My Hockey Players", itemIds: [9,10], isGlobalCategory: false),
//    ]
    
    static let items = [
        Item(id: 1, name: "John"),
        Item(id: 2, name: "Sarah"),
        Item(id: 3, name: "David"),
        Item(id: 4, name: "Alex"),
        Item(id: 5, name: "Olivia"),
        Item(id: 6, name: "Emily"),
        Item(id: 7, name: "Michael"),
        Item(id: 8, name: "Daniel"),
        Item(id: 9, name: "Isabella"),
        Item(id: 10, name: "Noah")
    ]
    
}


//struct MockClientData {
//    static let client = Client(id: 1, name: "Martin Bernat ", description: "Description of client 1", photoName: "client-photo")
//}

struct MockInfoRowData {
    static let cardTitles = ["AGE", "CHART", "DEVELOPER", "LANGUAGE"]
    static let cardValues = ["4+", "No.3", "SF Symbol", "EN"]
    static let cardDescriptions = ["Years Old", "Finance", "Diligent Robot", "(English)"]
}



struct MockItemCard{
    let id : Int
    let image: String
    let date: String
    let name: String
    let description1: String
    let description2: String
}
struct MockItemCardData {
    static let metricCards = [
        MockItemCard(id: 1, image: "metric-image", date: "30 MAY", name: "First Metric", description1: "14% in total", description2: "15kg of muscle"),
        MockItemCard(id: 2, image: "metric-image", date: "31 MAY", name: "Second Metric", description1: "15% in total", description2: "16kg of muscle"),
        MockItemCard(id: 3, image: "metric-image", date: "1 JUN", name: "Third Metric", description1: "16% in total", description2: "17kg of muscle"),
        MockItemCard(id: 4, image: "metric-image", date: "2 JUN", name: "Fourth Metric", description1: "17% in total", description2: "18kg of muscle"),
        MockItemCard(id: 5, image: "metric-image", date: "3 JUN", name: "Fifth Metric", description1: "18% in total", description2: "19kg of muscle")
    ]
    static let foodPlanCards = [
        MockItemCard(id: 1, image: "foodplan-maintain-image", date: "30 MAY", name: "Maintain", description1: "2000kcal", description2: ""),
        MockItemCard(id: 2, image: "foodplan-bulking-image", date: "1 JUN", name: "Hard Bulk", description1: "3000kcal", description2: ""),
        MockItemCard(id: 3, image: "foodplan-maintain-image", date: "2 JUN", name: "Maintain", description1: "2000kcal", description2: ""),
    ]
    static let photosCards = [
        MockItemCard(id: 1, image: "photo-image", date: "30 MAY", name: "Starting", description1: "", description2: ""),
        MockItemCard(id: 2, image: "photo-image", date: "1 JUN", name: "Hypertrophy 1.0", description1: "After", description2: ""),
        MockItemCard(id: 3, image: "photo-image", date: "2 JUN", name: "Hypertrophy 2.0", description1: "Before", description2: ""),
    ]
    static let trainingPlanCards = [
        MockItemCard(id: 1, image: "peak-logo",date: "30 MAY", name: "P9 - IN SEASON", description1: "MAXIMAL STRENGTH & ACCELERATION", description2: ""),
        MockItemCard(id: 2, image: "peak-logo",date: "30 MAY", name: "P8 - IN SEASON", description1: "MAXIMAL STRENGTH & ACCELERATION", description2: ""),
        MockItemCard(id: 3, image: "peak-logo",date: "30 MAY", name: "P7 - IN SEASON", description1: "MAXIMAL STRENGTH & ACCELERATION", description2: ""),
        MockItemCard(id: 4, image: "peak-logo",date: "30 MAY", name: "P6 - IN SEASON", description1: "MAXIMAL STRENGTH & ACCELERATION", description2: ""),
        MockItemCard(id: 5, image: "peak-logo",date: "30 MAY", name: "P5 - IN SEASON", description1: "MAXIMAL STRENGTH & ACCELERATION", description2: "")
    ]
}
















// mezocycle aj phases musia byt v jednej kategorii training protocol
// odkial ich budem potom filtrovat a rozdelovat

struct CategoryMock: Identifiable, Hashable {
    var id: Int
    var name: String
    var section: DataType
    var itemIDs: Set<Int> // Use a Set for unique elements and faster lookups
    var isGlobal: Bool
    var iconName: String
}

enum DataType: String {
    case client = "client"
    case exercise = "exercise"
    case trainingPlan = "trainingPlan"
    case mezocycle = "mezocycle"
    case phase = "phase"
    case foodPlan = "foodPlan"
    case measurement = "measurement"
    case progressAlbum = "progressAlbum"
}

enum SizeModel: String {
    case large = "Large"
    case medium = "Medium"
    case small = "Small"
}

protocol IdentifiableItem {
    var id: Int { get set }
    var dataType: DataType { get }
    var title: String { get set }
    var subTitle: String { get set }
    var categoryIDs: [Int] { get set }
    var imageName: String { get set }
    
    var clientID: Int? { get set }

}

struct ClientMock: IdentifiableItem, Identifiable, Hashable {
    var id: Int
    var dataType: DataType { .client }
    var title: String
    var subTitle: String
    var categoryIDs: [Int]
    var imageName = "client-photo"
    
    var clientID: Int? = nil

    
    var photoName: String
    var firstName: String
    var lastName: String
    var age: Int
    var weight: Int
    var height: Int
    
    var phaseIDs: [Int]
    var mezocycleIDs: [Int]
    var foodPlanIDs: [Int]
    var measurementIDs: [Int]
    var progressAlbumIDs: [Int]
}

struct ExerciseMock: IdentifiableItem, Identifiable, Hashable {
    var id: Int
    var dataType: DataType { .exercise }
    var title: String
    var subTitle: String
    var categoryIDs: [Int]
    var imageName = ""
    
    var clientID: Int? = nil

    
    var link: String
    var tags: [String]
}

struct TrainingSession {
    var date: Date
    var sets: Int
    var reps: Int
    var weight: Int
    // ... other properties and methods
}


struct PhaseMock: IdentifiableItem {
    var id: Int
    var dataType: DataType { .phase }
    var title: String
    var subTitle: String
    var categoryIDs: [Int]
    var imageName = "peak-logo"
    
    var clientID: Int?

    
    var exercisesIDs: [Int]
    var sessionsIDs: [Int]
    // ... other properties and methods
}

struct MezocycleMock: IdentifiableItem {
    var id: Int
    var dataType: DataType { .mezocycle }
    var title: String
    var subTitle: String
    var categoryIDs: [Int]
    var imageName = "peak-logo"
    
    var clientID: Int?

    
    var protocolsIDs: [Int]
    // ... other properties and methods
}

struct FoodPlanMock: IdentifiableItem {
    var id: Int
    var dataType: DataType { .foodPlan }
    var title: String
    var subTitle: String
    var categoryIDs: [Int]
    var imageName = "foodplan-maintain-image"
    
    var clientID: Int?

}

struct MeasurementMock: IdentifiableItem {
    var id: Int
    var dataType: DataType { .measurement }
    var title: String
    var subTitle: String
    var categoryIDs: [Int]
    var imageName = "metric-image"
    
    var clientID: Int?

}

struct ProgressAlbumMock: IdentifiableItem {
    var id: Int
    var dataType: DataType { .progressAlbum }
    var title: String
    var subTitle: String
    var categoryIDs: [Int]
    var imageName = "photo-image"
    
    var clientID: Int?
    

}







struct DataModelMock {
    static let categories: [CategoryMock] = [
        CategoryMock(id: 1, name: "All Clients", section: .client, itemIDs: Set((100...105)), isGlobal: true, iconName: "person.3.fill"),
        CategoryMock(id: 2, name: "Recent Clients", section: .client, itemIDs: Set((103...105)), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: 3, name: "My Clients", section: .client, itemIDs: Set([100, 101, 104, 105]), isGlobal: false, iconName: "person.2.fill"),
        CategoryMock(id: 4, name: "Favorite Clients", section: .client, itemIDs: Set([100, 105]), isGlobal: false, iconName: "star.fill"),
        
        CategoryMock(id: 5, name: "All Exercises", section: .exercise, itemIDs: Set((200...205)), isGlobal: true, iconName: "sportscourt.fill"),
        CategoryMock(id: 6, name: "Recent Exercises", section: .exercise, itemIDs: Set((203...205)), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: 7, name: "My Exercises", section: .exercise, itemIDs: Set([200, 201, 204, 205]), isGlobal: false, iconName: "sportscourt"),
        CategoryMock(id: 8, name: "Favorite Exercises", section: .exercise, itemIDs: Set([200, 205]), isGlobal: false, iconName: "star.fill"),
        
        CategoryMock(id: 9, name: "All Training Plans", section: .trainingPlan,
                     itemIDs: Set([300, 301, 302, 303, 304, 305, 400, 401]),
                     isGlobal: true, iconName: "list.bullet.rectangle"),
        CategoryMock(id: 10, name: "Recent Training Plans", section: .trainingPlan,
                     itemIDs: Set([300, 301, 302, 303, 304, 305, 400, 401]),
                     isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: 11, name: "My Training Plans", section: .trainingPlan,
                     itemIDs: Set([300, 301, 302, 303, 304, 305, 400, 401]),
                     isGlobal: false, iconName: "list.bullet.rectangle.portrait"),
        CategoryMock(id: 12, name: "Favorite Training Plans", section: .trainingPlan,
                     itemIDs: Set([300, 301, 302, 303, 304, 305, 400]),
                     isGlobal: false, iconName: "star.fill"),
        
//        CategoryMock(id: 13, name: "All Mezocycles", section: .mezocycle, itemIDs: Set((400...405)), isGlobal: true, iconName: "list.bullet.rectangle"),
//        CategoryMock(id: 14, name: "Recent Mezocycles", section: .mezocycle, itemIDs: Set((403...405)), isGlobal: true, iconName: "clock.fill"),
//        CategoryMock(id: 15, name: "My Mezocycles", section: .mezocycle, itemIDs: Set([400, 401, 404, 405]), isGlobal: false, iconName: "list.bullet.rectangle.portrait"),
//        CategoryMock(id: 16, name: "Favorite Mezocycles", section: .mezocycle, itemIDs: Set([400, 405]), isGlobal: false, iconName: "star.fill"),
        
        CategoryMock(id: 17, name: "All Food Plans", section: .foodPlan, itemIDs: Set((500...505)), isGlobal: true, iconName: "leaf.fill"),
        CategoryMock(id: 18, name: "Recent Food Plans", section: .foodPlan, itemIDs: Set((503...505)), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: 19, name: "My Food Plans", section: .foodPlan, itemIDs: Set([500, 501, 504, 505]), isGlobal: false, iconName: "leaf"),
        CategoryMock(id: 20, name: "Favorite Food Plans", section: .foodPlan, itemIDs: Set([500, 505]), isGlobal: false, iconName: "star.fill"),
        
        CategoryMock(id: 21, name: "All Metrics", section: .measurement, itemIDs: Set((600...605)), isGlobal: true, iconName: "chart.bar.fill"),
        CategoryMock(id: 22, name: "Recent Metrics", section: .measurement, itemIDs: Set((603...605)), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: 23, name: "My Metrics", section: .measurement, itemIDs: Set([600, 601, 604, 605]), isGlobal: false, iconName: "chart.bar"),
        CategoryMock(id: 24, name: "Favorite Metrics", section: .measurement, itemIDs: Set([600, 605]), isGlobal: false, iconName: "star.fill"),
        
        CategoryMock(id: 25, name: "All Progress Photos", section: .progressAlbum, itemIDs: Set((700...705)), isGlobal: true, iconName: "camera.fill"),
        CategoryMock(id: 26, name: "Recent Progress Photos", section: .progressAlbum, itemIDs: Set((703...705)), isGlobal: true, iconName: "clock.fill"),
        CategoryMock(id: 27, name: "My Progress Photos", section: .progressAlbum, itemIDs: Set([700, 701, 704, 705]), isGlobal: false, iconName: "camera"),
        CategoryMock(id: 28, name: "Favorite Progress Photos", section: .progressAlbum, itemIDs: Set([700, 705]), isGlobal: false, iconName: "star.fill"),
    ]
    
    // Client Data
    static let clients: [ClientMock] = [
        ClientMock(id: 100, title: "Josh Smith", subTitle: "Active", categoryIDs: [1, 3, 4], photoName: "client-photo", firstName: "Josh", lastName: "Smith", age: 32, weight: 190, height: 72, phaseIDs: [300, 301], mezocycleIDs: [400,401], foodPlanIDs: [500, 504], measurementIDs: [600, 601], progressAlbumIDs: [700, 701]),
        ClientMock(id: 101, title: "Emily Johnson", subTitle: "Active", categoryIDs: [1, 3], photoName: "client-photo", firstName: "Emily", lastName: "Johnson", age: 28, weight: 130, height: 65, phaseIDs: [302], mezocycleIDs: [400,401], foodPlanIDs: [503], measurementIDs: [602], progressAlbumIDs: [700, 701]),
        ClientMock(id: 102, title: "Michael Brown", subTitle: "Active", categoryIDs: [1, 3], photoName: "client-photo", firstName: "Michael", lastName: "Brown", age: 45, weight: 210, height: 74, phaseIDs: [303, 304], mezocycleIDs: [400,401], foodPlanIDs: [502, 505], measurementIDs: [603, 604], progressAlbumIDs: [700, 701]),
        ClientMock(id: 103, title: "Olivia Davis", subTitle: "Active", categoryIDs: [1, 3, 4], photoName: "client-photo",firstName: "Olivia", lastName: "Davis", age: 27, weight: 120, height: 64, phaseIDs: [305], mezocycleIDs: [400,401], foodPlanIDs: [501], measurementIDs: [605], progressAlbumIDs: [700, 701]),
        ClientMock(id: 104, title: "Daniel Garcia", subTitle: "Active", categoryIDs: [1, 3], photoName: "client-photo",firstName: "Daniel", lastName: "Garcia", age: 35, weight: 180, height: 70, phaseIDs: [301, 302], mezocycleIDs: [400,401], foodPlanIDs: [504, 505], measurementIDs: [606, 607], progressAlbumIDs: [700, 701]),
        ClientMock(id: 105, title: "Sophia Martinez", subTitle: "Active", categoryIDs: [1, 3, 4], photoName: "client-photo",firstName: "Sophia", lastName: "Martinez", age: 29, weight: 125, height: 66, phaseIDs: [300, 303], mezocycleIDs: [400,401], foodPlanIDs: [500, 503], measurementIDs: [608, 609], progressAlbumIDs: [700, 701]),
        ClientMock(id: 106, title: "William Wilson", subTitle: "Active", categoryIDs: [1, 3], photoName: "client-photo",firstName: "William", lastName: "Wilson", age: 42, weight: 200, height: 73, phaseIDs: [304, 305], mezocycleIDs: [400,401], foodPlanIDs: [502, 504], measurementIDs: [610, 611], progressAlbumIDs: [700, 701]),
        ClientMock(id: 107, title: "Ava Anderson", subTitle: "Active", categoryIDs: [1, 3, 4], photoName: "client-photo",firstName: "Ava", lastName: "Anderson", age: 25, weight: 115, height: 63, phaseIDs: [306, 307], mezocycleIDs: [400,401], foodPlanIDs: [505, 506], measurementIDs: [612, 613], progressAlbumIDs: [700, 701])

        // ... more clients
    ]

    // Exercise Data
    static let exercises: [ExerciseMock] = [
        ExerciseMock(id: 200, title: "Bench Press", subTitle: "Chest", categoryIDs: [5, 7, 8], link: "https://www.example.com/bench_press", tags: ["chest", "compound", "barbell"]),
        ExerciseMock(id: 201, title: "Deadlift", subTitle: "Lower Back", categoryIDs: [5, 7], link: "https://www.example.com/deadlift", tags: ["lower_back", "compound", "barbell"]),
        ExerciseMock(id: 202, title: "Squat", subTitle: "Legs", categoryIDs: [5, 7, 8], link: "https://www.example.com/squat", tags: ["legs", "compound", "barbell"]),
        ExerciseMock(id: 203, title: "Pull-Up", subTitle: "Back", categoryIDs: [5, 7], link: "https://www.example.com/pull_up", tags: ["back", "compound", "bodyweight"]),
        ExerciseMock(id: 204, title: "Dumbbell Shoulder Press", subTitle: "Shoulders", categoryIDs: [5, 7, 8], link: "https://www.example.com/dumbbell_shoulder_press", tags: ["shoulders", "compound", "dumbbell"]),
        ExerciseMock(id: 205, title: "Bicep Curl", subTitle: "Biceps", categoryIDs: [5, 7], link: "https://www.example.com/bicep_curl", tags: ["biceps", "isolation", "dumbbell"]),
        
        // ... more exercises
    ]

    // Training Protocol Data
    static let trainingProtocols: [PhaseMock] = [
        PhaseMock(id: 300, title: "Hypertrophy", subTitle: "PHASE 1", categoryIDs: [9, 11, 12], exercisesIDs: [200, 201], sessionsIDs: []),
        PhaseMock(id: 301,  title: "Strength", subTitle: "PHASE 1", categoryIDs: [9, 11], exercisesIDs: [200, 201], sessionsIDs: []),
        PhaseMock(id: 302, title: "Strength", subTitle: "PHASE 1", categoryIDs: [9, 11, 12], exercisesIDs: [200, 201, 202], sessionsIDs: [3000, 3001, 3002]),
        PhaseMock(id: 303, title: "Strength", subTitle: "PHASE 2", categoryIDs: [9, 11], exercisesIDs: [203, 204, 205], sessionsIDs: [3003, 3004, 3005]),
        PhaseMock(id: 304, title: "Mobility", subTitle: "PHASE 1", categoryIDs: [9, 11, 12], exercisesIDs: [202, 203, 204], sessionsIDs: [3006, 3007, 3008]),
        PhaseMock(id: 305, title: "Recovery", subTitle: "PHASE 1", categoryIDs: [9, 11], exercisesIDs: [201, 202, 205], sessionsIDs: [3009, 3010, 3011]),
        
        // ... more training protocols
    ]

    // Mezocycle Data
    static let mezocycles: [MezocycleMock] = [
        MezocycleMock(id: 400, title: "Movie Star Plan", subTitle: "3 months", categoryIDs: [9, 11, 12], protocolsIDs: [300, 301]),
        MezocycleMock(id: 401, title: "Spartan Plan", subTitle: "6 months", categoryIDs: [9, 11], protocolsIDs: [300, 301]),
        // ... more mezocycles
    ]

    // Food Plan Data
    static let foodPlans: [FoodPlanMock] = [
        FoodPlanMock(id: 500, title: "Maintain", subTitle: "4 weeks", categoryIDs: [17, 19, 20]),
        FoodPlanMock(id: 501, title: "Hard Bulk", subTitle: "8 weeks", categoryIDs: [17, 19]),
        // ... more food plans
    ]

    // Measurement Data
    static let measurements: [MeasurementMock] = [
        MeasurementMock(id: 600, title: "Josh Smith", subTitle: "1. measurement", categoryIDs: [21, 23, 24]),
        MeasurementMock(id: 601, title: "Emily Johnson", subTitle: "1. measurement", categoryIDs: [21, 23]),
        MeasurementMock(id: 602, title: "Michael Brown", subTitle: "1. measurement", categoryIDs: [21, 23, 24]),
        // ... more measurements
    ]

    // ProgressPhoto Data
    static let progressPhotos: [ProgressAlbumMock] = [
        ProgressAlbumMock(id: 700, title: "Josh Smith", subTitle: "1. album", categoryIDs: [25, 27, 28]),
        ProgressAlbumMock(id: 701, title: "Emily Johnson", subTitle: "1. album", categoryIDs: [25, 27]),
        ProgressAlbumMock(id: 702, title: "Michael Brown", subTitle: "1. album", categoryIDs: [25, 27, 28]),
        // ... more progress photos
    ]

}
