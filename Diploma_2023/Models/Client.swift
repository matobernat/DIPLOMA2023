//
//  Client.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/02/2023.
//

import Foundation

enum Gender: String, Decodable, Encodable, Hashable{
    case male = "Male"
    case female = "Female"
    case other = "Other"
    
    static var allCases: [Gender] {
        return [.male, .female, .other]
    }

    var placeholderImageName: String {
        switch self {
        case .male:
            return "clientAvatarMale"
        case .female:
            return "clientAvatarFemale"
        case .other:
            return "clientAvatar"
        }
    }
}



struct Client: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable  {

    //<IdentifiableItem properties>
    var id = UUID().uuidString // fireBase UID
    var dataType: DataType { .client }
    var title: String {
        return "\(firstName) \(lastName)"
    }
    var subTitle: String{
        return active ? "Active" : "Inactive"
    }
    var categoryIDs: [String]
    
    var placeholderName: String{
        return gender.placeholderImageName
    }
    
    var dateOfCreation: Date

    var clientID: String? = nil
    var accountID: String
    var profileID: String


    // personal info
    var firstName: String
    var lastName: String
    var gender: Gender = .other
    var imageUrl: String? = nil
    
    var email: String
    var phone: String
    
    var age: String
    var weight: String
    var height: String
    var active: Bool
    var allSessionsCount: Int = 0
    var doneSessionsCount: Int = 0

    
    // Info list row
    var trainingStyle: TrainingStyle
    var injury: String
    var healthIssues: String
    var paymentType: PaymentType
    

    var phases = [Phase]()
    var mezocycles =  [Mezocycle]()
    var progressAlbums: [ProgressAlbum]
    var measurements: [Measurements]
    var foodPlans: [FoodPlan]
    var foodPlanIDs: [String]
    var measurementIDs: [String]
    var progressAlbumIDs: [String]
}







// GET functions of the client
extension Client {
    func getAllPhases() -> [Phase] {
        var phases = self.phases

        for mezocycle in self.mezocycles {
            phases += mezocycle.phases
        }

        return phases
    }
}











// Phases + Mezos CRUD functions
extension Client{
    
    //MARK: Client - Mezocycle related func
    
    /// This function gets a mezocycle based on ID
    /// - Returns: Client's mezocycle
    func getClientMezo(mezoID: String) -> Mezocycle? {
        guard let index = self.mezocycles.firstIndex(where: { $0.id == mezoID }) else {
            // Mezocycle with the given ID not found, return nil
            return nil
        }
        return self.mezocycles[index]
        
    }
    
    
    /// This function add mezocycle to the client.
    func addMezo(mezo: Mezocycle) -> Client{
        var copy = self
        copy.mezocycles.append(mezo)
//        var newMezo = mezo.duplicate(existingTitles: existingTitles, keepName: true) // get mezo with new ID
//        copy.mezocycles.append(newMezo.AddMezoToClient(clientID: copy.id, clientName: copy.title))
        return copy
    }
    /// This function updates its mezocycle based on ID
    /// - Returns: The client with the updated mezocycle
    func updateMezo(mezo: Mezocycle) -> Client {
        guard let index = self.mezocycles.firstIndex(where: { $0.id == mezo.id }) else {
            // Mezocycle with the given ID not found, return the original client
            return self
        }
        var copy = self
        copy.mezocycles[index] = mezo
        
        return copy
    }
    /// This function deletes a mezocycle based on ID
    /// - Returns: The client with the deleted mezocycle
    func deleteMezo(mezoID: String) -> Client {
        var copy = self
        copy.mezocycles.removeAll(where: { $0.id == mezoID })
        
        return copy
    }
    
    
    //MARK: Client - Phase related func
    /// This function add phase to the client.
    /// - Returns: returned client have phase client ID and client name also set
    func addPhase(phase: Phase) -> Client{
        var copy = self
        copy.phases.append(phase)
        return copy
    }
    
    /// This function updates its phase based on ID
    /// - Returns: The client with the updated phase
    func updatePhase(phase: Phase) -> Client {
        guard let index = self.phases.firstIndex(where: { $0.id == phase.id }) else {
            // Mezocycle with the given ID not found, return the original client
            return self
        }
        var copy = self
        copy.phases[index] = phase
        
        return copy
    }
    /// This function deletes a phase based on ID
    /// - Returns: The client with the deleted phase
    func deletePhase(phaseID: String) -> Client {
        var copy = self
        copy.phases.removeAll(where: { $0.id == phaseID })
        
        return copy
    }
}




// ProgressAlbum CRUD functions
extension Client{

    /// - Returns: The client with the updated ProgressAlbum
    func updateAlbum(selectedAlbum: ProgressAlbum) -> Client {
        guard let index = self.progressAlbums.firstIndex(where: { $0.id == selectedAlbum.id }) else {
            // Mezocycle with the given ID not found, return the original client
            return self
        }
        var copy = self
        copy.progressAlbums[index] = selectedAlbum
        
        return copy
    }
    
    
    /// - Returns: The client with the updated ProgressAlbum
    func addAlbum(selectedAlbum: ProgressAlbum) -> Client {
        var copy = self
        copy.progressAlbums.append(selectedAlbum)
        return copy
    }
    
    /// - Returns: The client with the deleted ProgressAlbum
    func deleteAlbum(selectedAlbumId: String) -> Client {
        
        var copy = self
        copy.progressAlbums.removeAll(where: { $0.id == selectedAlbumId })
        return copy
    }
    
    
}

// FoodProtocol CRUD functions
extension Client{

    /// - Returns: The client with the updated FoodProtocol
    func updateFoodPlan(selectedItem: FoodPlan) -> Client {
        guard let index = self.foodPlans.firstIndex(where: { $0.id == selectedItem.id }) else {
            // FoodPlan with the given ID not found, return the original client
            return self
        }
        var copy = self
        copy.foodPlans[index] = selectedItem
        
        return copy
    }
    
    
    /// - Returns: The client with the updated FoodProtocol
    func addFoodPlan(selectedItem: FoodPlan) -> Client {
        var copy = self
        copy.foodPlans.append(selectedItem)
        return copy
    }
    
    /// - Returns: The client with the deleted FoodProtocol
    func deleteFoodPlan(selectedItemId: String) -> Client {
        
        var copy = self
        copy.foodPlans.removeAll(where: { $0.id == selectedItemId })
        return copy
    }
    
    
}




// static factory methods
extension Client{
    
    static func gender(from isMale: Bool?) -> Gender {
        if let isMale = isMale {
            return isMale ? .male : .female
        } else {
            return .other
        }
    }
    
    func getProgressAlbumIndex(progressAlbumId: String) -> Int?{
        return self.progressAlbums.firstIndex(where: { $0.id == progressAlbumId})
    }
    
    func getMeasurementIndex(measurementId: String) -> Int? {
        return measurements.firstIndex { $0.id == measurementId }
    }
    
    static func getNewClient( categoryIDs : [String], accountID: String, profileID: String) -> Client{
        return Client(
                categoryIDs: categoryIDs,
                dateOfCreation: .now,
                accountID: accountID,
                profileID: profileID,
                firstName: "",
                lastName: "",
                gender: Gender.other,
                email: "",
                phone: "",
                age: "",
                weight: "",
                height: "",
                active: true,
                trainingStyle: .inPerson,
                injury: "",
                healthIssues: "",
                paymentType: .perSession,
                phases: [],
                mezocycles: [],
                progressAlbums: [],
                measurements: [],
                foodPlans: [],
                foodPlanIDs: [],
                measurementIDs: [],
                progressAlbumIDs: [])
    }
    
    
    static func createMockClient(categoryIDs : [String], accountID: String, profileID: String) -> Client {
        let firstNames = ["John", "Jane", "Michael", "Mary", "James", "Emily", "David", "Emma", "Robert", "Olivia"]
        let lastNames = ["Smith", "Johnson", "Brown", "Williams", "Jones", "Miller", "Davis", "Garcia", "Taylor", "Martinez"]

        let randomFirstName = firstNames.randomElement()!
        let randomLastName = lastNames.randomElement()!
        let randomEmail = "\(randomFirstName.lowercased()).\(randomLastName.lowercased())@gmail.com"
        let randomPhoneNumber = String(format: "%03d-%03d-%04d", Int.random(in: 100...999), Int.random(in: 100...999), Int.random(in: 1000...9999))
        let randomAge = Int.random(in: 18...65)
        let randomWeight = Int.random(in: 100...250)
        let randomHeight = Int.random(in: 150...200)

        return Client(
            categoryIDs: categoryIDs,
            dateOfCreation: Date.now,
            accountID: accountID,
            profileID: profileID,

            firstName: randomFirstName,
            lastName: randomLastName,
            gender: Gender.allCases.randomElement() ?? .other,

            email: randomEmail,
            phone: randomPhoneNumber,

            age: String(randomAge),
            weight: String(randomWeight),
            height: String(randomHeight),

            active: Bool.random(),
            trainingStyle: TrainingStyle.allCases.randomElement()!,
            injury: "None",
            healthIssues: "None",
            paymentType: PaymentType.allCases.randomElement()!,

            phases: [],
            mezocycles: [],
            progressAlbums: [],
            measurements: [],
            foodPlans: [],
            foodPlanIDs: [],
            measurementIDs: [],
            progressAlbumIDs: []
        )
    }
}





// Remaining Tranings Logic calculations
extension Client{
    
    func calculateFinishedPhasesPercentage() -> Double {

        let totalAvailableSessions = self.getTotalAvailableSessions()
        let totalFinishedSessions = self.getTotalFinishedSessions()
        
        if totalAvailableSessions == 0 {
            return 0 // Avoid division by zero
        }
        let finishedPercentage = Double(totalFinishedSessions) / Double(totalAvailableSessions) * 100.0
        print ("PERCENTAGE:\(finishedPercentage)  \(totalFinishedSessions) finished   \(totalAvailableSessions) available ")

        return finishedPercentage
    }
    
    
    
//The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions
    
//    func getTotalAvailableSessions() ->Int{
//        let totalAvailableSessions = self.phases.reduce(0) { $0 + $1.getNumberOfAllAvailableSessions() } +
//        self.mezocycles.reduce(0) { $0 + $1.getNumberOfAllAvailableSessions() }
//        return totalAvailableSessions
//    }
    
    func getTotalAvailableSessions() -> Int {
        let phaseSessions: Int = self.phases.reduce(0) { (total, phase) in
            total + phase.getNumberOfAllAvailableSessions()
        }
        let mezoSessions: Int = self.mezocycles.reduce(0) { (total, mezo) in
            total + mezo.getNumberOfAllAvailableSessions()
        }
        return phaseSessions + mezoSessions
    }

    
    
//    func getTotalFinishedSessions() ->Int{
//        let totalFinishedSessions = self.phases.reduce(0) { $0 + $1.getNumberOfAllFinishedSessions() } +
//        self.mezocycles.reduce(0) { $0 + $1.getNumberOfAllFinishedSessions() }
//        return totalFinishedSessions
//    }
//
    
    
    func getTotalFinishedSessions() -> Int {
        let phaseFinishedSessions: Int = self.phases.reduce(0) { (total, phase) in
            total + phase.getNumberOfAllFinishedSessions()
        }
        let mezoFinishedSessions: Int = self.mezocycles.reduce(0) { (total, mezo) in
            total + mezo.getNumberOfAllFinishedSessions()
        }
        return phaseFinishedSessions + mezoFinishedSessions
    }


}
